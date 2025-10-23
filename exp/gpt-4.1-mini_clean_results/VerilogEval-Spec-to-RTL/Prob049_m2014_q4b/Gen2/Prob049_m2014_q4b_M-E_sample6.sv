module TopModule (
    input  clk,
    input  ar,    // Asynchronous reset, active high
    input  d,
    output reg q
);

    reg reset_latch;

    // Asynchronous reset latch stage - level sensitive to ar
    always @(*) begin
        if (ar)
            reset_latch = 1'b1;
        else
            reset_latch = 1'b0;
    end

    // Positive edge triggered flip-flop stage
    always @(posedge clk) begin
        if (reset_latch)
            q <= 1'b0;  // Clear asynchronously indicated by latch
        else
            q <= d;
    end

endmodule