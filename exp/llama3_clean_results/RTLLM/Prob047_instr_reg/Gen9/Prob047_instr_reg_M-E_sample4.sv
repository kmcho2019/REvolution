module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [15:0] ins_reg;  // 16-bit register to store instructions from both sources

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_reg <= 16'd0;
    end else begin
        case (fetch)
            2'b01: ins_reg[7:0] <= data;  // Update lower 8 bits with data
            2'b10: ins_reg[15:8] <= data;  // Update upper 8 bits with data
            default: ;  // No update for other fetch values
        endcase
    end
end

assign ins = ins_reg[7:5];  // High 3 bits of the lower 8 bits
assign ad1 = ins_reg[4:0];  // Low 5 bits of the lower 8 bits
assign ad2 = ins_reg[15:8];  // Upper 8 bits

endmodule