
// ==================================================================================================================
// Name        : SimpleCpu
// Author      : Gokhan Gobus
// Version     : 
// Copyright   : Gokhan Gobus
// Description :  Designed a CPU for simple  operations on the fpga chip. 
// =================================================================================================================


`timescale 1ns / 1ps
module SimpleCPU(clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);

parameter SIZE = 10;

input clk, rst;
input wire [31:0] data_fromRAM;
output reg wrEn;
output reg [SIZE-1:0] addr_toRAM;
output reg [31:0] data_toRAM;



reg [2:0] stateCurrent,stateNext;
reg [31:0] reg1,reg1Next;
reg [31:0] reg2,reg2Next;
reg [31:0] result,resultNext;
reg [31:0] IW,IWNext;
reg [9:0] PC,PCNext;

always@(posedge clk) begin
	if(rst) begin
		stateCurrent <= 3'b000;
		reg1<=0;
		reg2<=0;
		result<=0;
		IW<=0;
		PC<=0;
		//...
	end else begin
		stateCurrent<=stateNext;
		reg1<=reg1Next;
		reg2<=reg2Next;
		result<=resultNext;
		IW<=IWNext;
		PC<=PCNext;
		//...
	end
end

always@(*) begin
	//default values
	addr_toRAM=0;
	data_toRAM=0;
	wrEn=0;
	stateNext=stateCurrent;


	

	case(stateCurrent)
	
		3'b000: begin //program counter
		wrEn=1'b0;
		addr_toRAM=PC;
		PCNext=PC+1'b1;
		stateNext=3'b001;
	end
	3'b001 : begin //get instruction
		IWNext=data_fromRAM;
		
		stateNext=3'b010;
	end
	3'b010 : begin // decode and execute
		if(IW[31:29]==3'b000) begin //add
			// reguest element a
			addr_toRAM=IW[27:14];
			
		end else if(IW[31:29]==3'b001) begin // nand
			//reguest element a
			addr_toRAM=IW[27:14];
		end else if(IW[31:29]==3'b010) begin  //srl
			addr_toRAM=IW[27:14];
		end else if(IW[31:29]==3'b011) begin //lt
			addr_toRAM=IW[27:14];
		end else if(IW[31:29]==3'b100) begin //cp
			
		end else if(IW[31:29]==3'b101) begin //cpı
			if(IW[28:28]==1'b1) begin
				addr_toRAM=IW[27:14];
			end else begin 
				addr_toRAM=IW[13:0];
			end
		end else if(IW[31:29]==3'b110) begin //brj
			if(IW[28:28]==1'b1) begin
				reg2Next=IW[13:0];
				addr_toRAM=IW[27:14];
			end else begin 
				addr_toRAM=IW[13:0];
			end
		end else if(IW[31:29]==3'b111) begin //mull
			addr_toRAM=IW[27:14];
		end else begin end

		stateNext=3'b011;
	end
	3'b011 : begin //execute s3
		if(IW[31:29]==3'b000) begin //add
			reg1Next=data_fromRAM;
			if(IW[28:28]==1'b1) begin

			end else begin 
				addr_toRAM=IW[13:0];  //b request
			end
		end else if(IW[31:29]==3'b001) begin // nand
			reg1Next=data_fromRAM;
			if(IW[28:28]==1'b1) begin

			end else begin 
				addr_toRAM=IW[13:0]; //b request
			end
		end else if(IW[31:29]==3'b010) begin  //srl
			reg1Next=data_fromRAM;
			if(IW[28:28]==1'b1) begin

			end else begin 
				addr_toRAM=IW[13:0];
			end
		end else if(IW[31:29]==3'b011) begin //lt
			reg1Next=data_fromRAM;
			if(IW[28:28]==1'b1) begin

			end else begin 
				addr_toRAM=IW[13:0];
			end
		end else if(IW[31:29]==3'b100) begin //cp
			if(IW[28:28]==1'b1) begin
				
			end else begin 
				addr_toRAM=IW[13:0];
			end
		end else if(IW[31:29]==3'b101) begin //cpı
			if(IW[28:28]==1'b1) begin
				reg1Next=data_fromRAM;
				addr_toRAM=IW[13:0];
			end else begin 
				reg2Next=data_fromRAM;
				addr_toRAM=reg2[13:0];
			end
		end else if(IW[31:29]==3'b110) begin //brj
			if(IW[28:28]==1'b1) begin
				reg1Next=data_fromRAM;
			end else begin 
				reg2Next=data_fromRAM;
			end
		end else if(IW[31:29]==3'b111) begin //mull
			reg1Next=data_fromRAM;
			if(IW[28:28]==1'b1) begin

			end else begin 
				addr_toRAM=IW[13:0];
			end
		end else begin end

		stateNext=3'b100;
	end
	3'b100 : begin // s4
		if(IW[31:29]==3'b000) begin //add
			if(IW[28:28]==1'b1) begin
				reg2Next={18'd0,IW[13:0]};
			end else begin 
				reg2Next=data_fromRAM;
			end
			stateNext=3'b101;
		end else if(IW[31:29]==3'b001) begin // nand
			if(IW[28:28]==1'b1) begin
				reg2Next={18'd0,IW[13:0]};
			end else begin 
				reg2Next=data_fromRAM;
			end
			stateNext=3'b101;
		end else if(IW[31:29]==3'b010) begin  //srl
			if(IW[28:28]==1'b1) begin
				reg2Next={18'd0,IW[13:0]};
			end else begin 
				reg2Next=data_fromRAM;
			end
			stateNext=3'b101;
		end else if(IW[31:29]==3'b011) begin //lt
			if(IW[28:28]==1'b1) begin
				reg2Next={18'd0,IW[13:0]};
			end else begin 
				reg2Next=data_fromRAM;
			end
			stateNext=3'b101;
		end else if(IW[31:29]==3'b100) begin //cp
			if(IW[28:28]==1'b1) begin
				reg2Next={18'd0,IW[13:0]};
			end else begin 
				reg2Next=data_fromRAM;
			end
			stateNext=3'b101;
		end else if(IW[31:29]==3'b101) begin //cpı
			if(IW[28:28]==1'b1) begin
				reg2Next=data_fromRAM;
			end else begin 
				reg2Next=data_fromRAM;
				addr_toRAM=IW[27:14];
			end
			stateNext=3'b101;
		end else if(IW[31:29]==3'b110) begin //brj
			if(IW[28:28]==1'b1) begin
				
			end else begin 
				if(reg2==32'd0) begin
					addr_toRAM=IW[27:14];
					stateNext=3'b101;
				end else begin
					stateNext=3'b000;
				end
			end
		end else if(IW[31:29]==3'b111) begin //mull
			if(IW[28:28]==1'b1) begin
				reg2Next={18'd0,IW[13:0]};
			end else begin 
				reg2Next=data_fromRAM;
			end
			stateNext=3'b101;
		end else begin
			stateNext=3'b101;
		 end

		
	end
	3'b101: begin // s5
		if(IW[31:29]==3'b000) begin //add
			result=reg1+reg2;
		end else if(IW[31:29]==3'b001) begin // nand
			result=~(reg1&reg2);
		end else if(IW[31:29]==3'b010) begin  //srl
			result=(reg2 < 14'd32) ? (reg1 >> reg2):(reg1 << (reg2 - 14'd32));
		end else if(IW[31:29]==3'b011) begin //lt
			result=(reg1 < reg2) ? 32'd1:32'd0;
		end else if(IW[31:29]==3'b100) begin //cp
			result= reg2;
		end else if(IW[31:29]==3'b101) begin //cpı
			if(IW[28:28]==1'b1) begin
				result=reg2;
			end else begin 
				reg1Next=data_fromRAM;
			end
		end else if(IW[31:29]==3'b110) begin //brj
			if(IW[28:28]==1'b1) begin
				result=reg1+reg2;
			end else begin 
				reg1Next=data_fromRAM;
			end
		end else if(IW[31:29]==3'b111) begin //mull
			result=reg1*reg2;
		end else begin end

		stateNext=3'b110;
	end
	3'b110: begin // s6
		if(IW[31:29]==3'b000) begin //add
			data_toRAM=result;
			addr_toRAM=IW[27:14];
			wrEn=1'b1;
			//end of addder so
			stateNext=3'b000;
		end else if(IW[31:29]==3'b001) begin // nand
			data_toRAM=result;
			addr_toRAM=IW[27:14];
			wrEn=1'b1;
			//end of nander so
			stateNext=3'b000;
		end else if(IW[31:29]==3'b010) begin  //srl
			data_toRAM=result;
			addr_toRAM=IW[27:14];
			wrEn=1'b1;
			//end of srl so
			stateNext=3'b000;
		end else if(IW[31:29]==3'b011) begin //lt
			data_toRAM=result;
			addr_toRAM=IW[27:14];
			wrEn=1'b1;
			//end of lt so
			stateNext=3'b000;
		end else if(IW[31:29]==3'b100) begin //cp
			data_toRAM=result;
			addr_toRAM=IW[27:14];
			wrEn=1'b1;
			//end of cp so
			stateNext=3'b000;
		end else if(IW[31:29]==3'b101) begin //cpı
			if(IW[28:28]==1'b1) begin
					data_toRAM=result;
					addr_toRAM=reg1[13:0];
					wrEn=1'b1;
					//end of cpıi so
					stateNext=3'b000;
			end else begin 
					result=reg2;
					stateNext=3'b111;
			end
		end else if(IW[31:29]==3'b110) begin //brj
			if(IW[28:28]==1'b1) begin
				PCNext=result[9:0];
				stateNext=3'b000;
			end else begin 
				PCNext=reg1[9:0];
				stateNext=3'b000;
			end
		end else if(IW[31:29]==3'b111) begin //mull
			data_toRAM=result;
			addr_toRAM=IW[27:14];
			wrEn=1'b1;
			//end of mull so
			stateNext=3'b000;
		end else begin 
			stateNext=3'b111;
		end

		
	end
	3'b111: begin // s7
				
		if(IW[31:29]==3'b101) begin //cpı
			if(IW[28:28]==1'b1) begin

			end else begin 
				data_toRAM=result;
				addr_toRAM=IW[27:14];
				wrEn=1'b1;
				//end of cpı so
				stateNext=3'b000;
			end
		end else begin end
		stateNext=3'b000;

	end
	default: begin end


	endcase
	end
endmodule