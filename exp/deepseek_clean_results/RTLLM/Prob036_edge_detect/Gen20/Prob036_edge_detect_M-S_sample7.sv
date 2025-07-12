module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev = 1'b0;

    always @(posedge clk) begin
        a_prev <= a;
    end

    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule