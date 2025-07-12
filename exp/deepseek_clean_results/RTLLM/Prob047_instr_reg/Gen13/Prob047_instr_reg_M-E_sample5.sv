module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Unified 16-bit shift register (stores both instructions)
    reg [15:0] shift_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_reg <= 16'b0;
        end
        else begin
            case (fetch)
                2'b01: shift_reg[15:8] <= data;  // Load into upper byte
                2'b10: shift_reg[7:0] <= data;   // Load into lower byte
                default: shift_reg <= {shift_reg[7:0], shift_reg[15:8]};  // Circular shift
            endcase
        end
    end

    // Output assignments from specific register positions
    assign ins = shift_reg[15:13];  // Upper 3 bits of first instruction
    assign ad1 = shift_reg[12:8];   // Lower 5 bits of first instruction
    assign ad2 = shift_reg[7:0];    // Full second instruction

endmodule