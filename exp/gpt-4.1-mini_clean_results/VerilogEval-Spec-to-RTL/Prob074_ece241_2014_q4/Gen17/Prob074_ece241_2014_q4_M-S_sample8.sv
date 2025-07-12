module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] ff;  // ff[2]: XOR flip-flop, ff[1]: AND flip-flop, ff[0]: OR flip-flop

    wire d_xor = x ^ ff[2];
    wire d_and = x & ~ff[1];
    wire d_or  = x | ~ff[0];

    always @(posedge clk) begin
        ff <= {d_xor, d_and, d_or};
    end

    assign z = ~(ff[2] | ff[1] | ff[0]);

endmodule