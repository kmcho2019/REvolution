module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [15:0] shift_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_reg <= 16'h0000;
        end else begin
            case (fetch)
                2'b01: shift_reg[7:0] <= data;    // Load lower byte
                2'b10: shift_reg[15:8] <= data;   // Load upper byte
                default: shift_reg <= shift_reg;   // Hold current value
            endcase
        end
    end

    // Output assignments from fixed positions in shift register
    assign ins = shift_reg[10:8];    // Bits 10-8 for opcode
    assign ad1 = shift_reg[4:0];     // Bits 4-0 for register address
    assign ad2 = shift_reg[15:8];    // Upper byte for full data

endmodule