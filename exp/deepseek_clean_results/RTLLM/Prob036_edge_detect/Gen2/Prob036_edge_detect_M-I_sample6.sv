module edge_detect (
    input clk,
    input rst_n,  // Kept for interface compatibility but not used
    input a,
    output rise,
    output down
);

    reg a_prev = 1'b0;  // Initialized to 0 (simulation only)

    always @(posedge clk) begin
        a_prev <= a;
    end

    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule