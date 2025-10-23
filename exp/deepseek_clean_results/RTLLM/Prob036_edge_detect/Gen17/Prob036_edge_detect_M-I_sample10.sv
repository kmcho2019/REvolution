module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;
    wire a_change = (a != a_prev);  // Clock enable condition

    always @(posedge clk) begin
        if (a_change) begin
            a_prev <= a;
        end
    end

    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule