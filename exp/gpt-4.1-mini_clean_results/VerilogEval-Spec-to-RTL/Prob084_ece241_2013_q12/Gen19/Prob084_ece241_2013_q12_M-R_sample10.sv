module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] shift_reg;
    wire [2:0] sel = {A, B, C};
    wire [2:0] idx = ~sel;  // invert bits to map ABC=0 -> shift_reg[7], ABC=7 -> shift_reg[0]

    always @(posedge clk) begin
        if (enable) begin
            // Shift right with MSB loaded with S, shift_reg[7] is Q[0]
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    assign Z = shift_reg[idx];

endmodule