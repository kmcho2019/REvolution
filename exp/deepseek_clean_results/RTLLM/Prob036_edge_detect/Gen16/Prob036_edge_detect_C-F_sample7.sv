module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;

    // Register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Compact edge detection
    assign rise = ~a_prev & a;
    assign down = a_prev & ~a;

endmodule