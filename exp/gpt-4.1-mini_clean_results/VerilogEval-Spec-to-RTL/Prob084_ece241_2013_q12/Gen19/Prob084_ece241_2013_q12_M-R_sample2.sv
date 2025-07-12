module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] shift_reg;
    wire [2:0] sel = {A, B, C};
    wire [2:0] rev_sel = 3'd7 - sel; // Reverse index: ABC=0 -> 7, ABC=7 -> 0

    // Shift register update: shift right by 1 with S shifted in at MSB (shift_reg[7])
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    // Multiplexer implemented as assign selecting the bit at rev_sel
    assign Z = shift_reg[rev_sel];

endmodule