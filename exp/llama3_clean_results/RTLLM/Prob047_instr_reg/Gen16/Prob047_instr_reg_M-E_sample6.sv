module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Instruction Fetch Module
module instr_fetch(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [7:0] ins_p1, // Fetched instruction 1
    output [7:0] ins_p2  // Fetched instruction 2
);

reg [7:0] ins_buf1;  // Buffer for instruction 1
reg [7:0] ins_buf2;  // Buffer for instruction 2

wire clk_gated1 = (fetch == 2'b01)? clk : 1'b0;
wire clk_gated2 = (fetch == 2'b10)? clk : 1'b0;

always @(posedge clk_gated1 or negedge rst) begin
    if (!rst) begin
        ins_buf1 <= 8'd0;
    end else begin
        ins_buf1 <= data;
    end
end

always @(posedge clk_gated2 or negedge rst) begin
    if (!rst) begin
        ins_buf2 <= 8'd0;
    end else begin
        ins_buf2 <= data;
    end
end

assign ins_p1 = ins_buf1;
assign ins_p2 = ins_buf2;

endmodule

// Instruction Decode Module
module instr_decode(
    input [7:0] ins_p1, // Fetched instruction 1
    input [7:0] ins_p2, // Fetched instruction 2

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

assign ins = ins_p1[7:5];  // High 3 bits of the first instruction
assign ad1 = ins_p1[4:0];  // Low 5 bits of the first instruction
assign ad2 = ins_p2;       // Full 8-bit data from the second instruction

endmodule

// Instantiate modules
wire [7:0] ins_p1;
wire [7:0] ins_p2;

instr_fetch fetch_unit(
   .clk(clk),
   .rst(rst),
   .fetch(fetch),
   .data(data),
   .ins_p1(ins_p1),
   .ins_p2(ins_p2)
);

instr_decode decode_unit(
   .ins_p1(ins_p1),
   .ins_p2(ins_p2),
   .ins(ins),
   .ad1(ad1),
   .ad2(ad2)
);

endmodule