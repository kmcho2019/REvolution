module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    assign rise = a & ~a_prev;  // 0->1 transition
    assign down = ~a & a_prev;  // 1->0 transition

endmodule