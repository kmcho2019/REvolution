module instr_reg_mod(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Internal signals
reg [7:0] ins_p1;  // First 8-bit register for instructions
reg [7:0] ins_p2;  // Second 8-bit register for instructions
reg [2:0] ins_out;  // Output signal for ins
reg [4:0] ad1_out;  // Output signal for ad1
reg [7:0] ad2_out;  // Output signal for ad2

// Control unit module
module control_unit(
    input [1:0] fetch,  // Control signal
    input [7:0] data,  // Data input
    output reg [7:0] ins_p1,  // First register output
    output reg [7:0] ins_p2  // Second register output
);
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_p1 <= 8'd0;  // Reset first register
        ins_p2 <= 8'd0;  // Reset second register
    end else if (fetch == 2'b01) begin
        ins_p1 <= data;  // Update first register
    end else if (fetch == 2'b10) begin
        ins_p2 <= data;  // Update second register
    end
end
endmodule

// Decoder module
module decoder(
    input [7:0] ins_p1,  // First register input
    input [7:0] ins_p2,  // Second register input
    output [2:0] ins,  // Output signal for ins
    output [4:0] ad1,  // Output signal for ad1
    output [7:0] ad2  // Output signal for ad2
);
assign ins = ins_p1[7:5];  // High 3 bits of the instruction
assign ad1 = ins_p1[4:0];  // Low 5 bits of the instruction
assign ad2 = ins_p2;  // Full 8-bit data from the second source
endmodule

// Instantiate control unit and decoder modules
control_unit cu(
    .fetch(fetch),
    .data(data),
    .ins_p1(ins_p1),
    .ins_p2(ins_p2)
);

decoder dec(
    .ins_p1(ins_p1),
    .ins_p2(ins_p2),
    .ins(ins_out),
    .ad1(ad1_out),
    .ad2(ad2_out)
);

// Assign output signals
assign ins = ins_out;
assign ad1 = ad1_out;
assign ad2 = ad2_out;

endmodule