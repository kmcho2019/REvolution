module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // 8-bit shift register (Q[7] is the MSB shifted in first)
    reg [7:0] Q;

    // On reset or power up initialize Q to 0 (optional)
    initial Q = 8'b0;

    // On rising edge of clk, shift right when enabled, new bit goes to Q[7]
    always @(posedge clk) begin
        if (enable)
            Q <= {S, Q[7:1]};
    end

    // Multiplexer: output Z is selected by 3-bit input {A,B,C} indexing Q[0]...Q[7]
    // Since Q[0] is LSB, and Q[7] is MSB, the index matches natural order of {A,B,C}
    assign Z = Q[{A,B,C}];

endmodule