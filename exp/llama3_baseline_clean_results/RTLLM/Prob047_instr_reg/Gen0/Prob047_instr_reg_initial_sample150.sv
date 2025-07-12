module instr_reg(
    input clk, // Clock signal
    input rst, // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction to be fetched
    output [2:0] ins, // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1, // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2 // The full 8-bit data from the second source
);

reg [7:0] ins_p1; // 8-bit register to store instructions from the first source
reg [7:0] ins_p2; // 8-bit register to store instructions from the second source

// On the rising edge of the clock, if the reset signal is low, both registers are initialized to zero
always @(posedge clk) begin
    if (~rst) begin
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        // Based on the fetch signal, update the corresponding register
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: ; // No update
        endcase
    end
end

// Derive the outputs from the stored instructions in ins_p1
assign ins = ins_p1[7:5]; // High 3 bits of the instruction
assign ad1 = ins_p1[4:0]; // Low 5 bits of the instruction
assign ad2 = ins_p2; // The full 8-bit data from the second source

endmodule