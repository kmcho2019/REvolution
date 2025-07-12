module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [15:0] instr_shift_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_shift_reg <= 16'b0;
        end else begin
            case (fetch)
                2'b01: instr_shift_reg <= {instr_shift_reg[15:8], data};  // Load lower byte
                2'b10: instr_shift_reg <= {data, instr_shift_reg[7:0]};   // Load upper byte
                default: instr_shift_reg <= instr_shift_reg;               // Hold current value
            endcase
        end
    end

    // Output assignments remain the same
    assign ins = instr_shift_reg[7:5];  // Upper 3 bits of lower byte
    assign ad1 = instr_shift_reg[4:0];   // Lower 5 bits of lower byte
    assign ad2 = instr_shift_reg[15:8];  // Entire upper byte

endmodule