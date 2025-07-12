module TopModule (
    input  clk,
    input  ar,    // Asynchronous active-high reset
    input  d,
    output q
);

    // Asynchronous reset latch: when ar=1, reset_latch=0 immediately.
    reg reset_latch;
    always @(ar or reset_latch) begin
        if (ar)
            reset_latch = 1'b0;  // force low asynchronously
        else
            reset_latch = 1'b1;  // release reset asynchronously
    end

    // Positive-edge triggered D flip-flop storing data
    reg q_int;
    always @(posedge clk) begin
        if (reset_latch) // only update q_int if not in reset
            q_int <= d;
    end

    // Output is gated: when reset is active, output forced low immediately
    assign q = reset_latch & q_int;

endmodule