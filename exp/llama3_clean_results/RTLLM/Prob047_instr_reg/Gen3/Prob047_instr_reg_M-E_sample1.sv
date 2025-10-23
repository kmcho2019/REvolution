module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [15:0] ins_reg;  // Single 16-bit register to store both instructions

// Reset logic
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_reg <= 16'd0; // Initialize ins_reg to zero on reset
    end
    else begin
        case (fetch)
            2'b01: ins_reg[7:0] <= data; // Fetch instruction into lower 8 bits when fetch is 2'b01
            2'b10: ins_reg[15:8] <= data; // Fetch instruction into upper 8 bits when fetch is 2'b10
        endcase
    end
end

// Output logic
assign ins = ins_reg[7:5];  // High 3 bits of the instruction in lower 8 bits
assign ad1 = ins_reg[4:0];  // Low 5 bits of the instruction in lower 8 bits
assign ad2 = ins_reg[15:8]; // Full 8-bit data from upper 8 bits

endmodule