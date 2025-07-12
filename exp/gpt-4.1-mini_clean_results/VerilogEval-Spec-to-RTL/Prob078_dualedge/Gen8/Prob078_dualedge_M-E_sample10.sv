module TopModule (
    input  clk,
    input  d,
    output q
);
    // Internal registers
    reg d_pos;    // Captures input at posedge clk
    reg d_neg;    // Captures d_pos at posedge of inverted clk (simulate negedge clk)

    // Positive edge flip-flop clocked on clk
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Positive edge flip-flop clocked on inverted clk (to simulate negedge clk)
    always @(posedge ~clk) begin
        d_neg <= d_pos;
    end

    // XOR output toggles on both edges capturing changes on posedge and negedge
    assign q = d_pos ^ d_neg;

endmodule