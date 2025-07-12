module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    reg reset_latch;

    // Asynchronous latch for reset path: active-high async reset
    always @(*) begin
        if (ar)
            reset_latch = 1'b1;  // latch '1' when reset asserted
        else if (!ar)
            reset_latch = 1'b0;  // latch '0' when reset deasserted
    end

    // Positive-edge triggered flip-flop with reset controlled via reset_latch
    always @(posedge clk) begin
        if (reset_latch)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule