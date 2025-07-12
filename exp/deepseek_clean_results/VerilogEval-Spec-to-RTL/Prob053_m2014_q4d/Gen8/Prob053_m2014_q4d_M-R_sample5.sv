module TopModule (
    input clk,
    input in,
    output out
);

    reg state;

    // Combined XOR and flip-flop in continuous assignment
    assign out = state;
    always @(posedge clk) state <= state ^ in;

endmodule