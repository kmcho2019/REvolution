module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [15:0] shift_reg;

    always @(posedge clk) begin
        // Shift in the current input as the upper 8 bits,
        // previous input is preserved in lower 8 bits.
        shift_reg <= {shift_reg[7:0], in};

        // Detect 0->1 transitions by comparing old bits (shift_reg[7:0]) and new bits (shift_reg[15:8])
        pedge <= (~shift_reg[7:0]) & shift_reg[15:8];
    end

endmodule