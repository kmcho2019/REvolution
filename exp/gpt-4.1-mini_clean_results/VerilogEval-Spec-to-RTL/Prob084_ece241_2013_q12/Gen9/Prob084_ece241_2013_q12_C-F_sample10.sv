module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // 8-bit shift register to hold memory content (Q[0] is MSB shifted in first)
    reg [7:0] Q;

    // On each rising edge of clk, shift in S at Q[0] when enable is high
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Multiplexer: output Z is selected by the 3-bit input {A,B,C} indexing into Q
    assign Z = Q[{A,B,C}];

endmodule