module TopModule (
    input  clk,
    input  ar,     // asynchronous active-high reset
    input  d,
    output q
);

    wire ff_out;
    wire reset_latch_out;

    // First, a positive edge triggered D flip-flop (no async reset)
    reg dff_q;
    always @(posedge clk) begin
        dff_q <= d;
    end
    assign ff_out = dff_q;

    // Asynchronous reset latch:
    // When ar=1, latch output forces 0 asynchronously
    // When ar=0, latch transparently passes flip-flop output asynchronously
    reg async_reset_latch;
    always @(*) begin
        if (ar)
            async_reset_latch = 1'b0;
        else
            async_reset_latch = ff_out;
    end
    assign reset_latch_out = async_reset_latch;

    // Output driven by the asynchronous reset latch
    assign q = reset_latch_out;

endmodule