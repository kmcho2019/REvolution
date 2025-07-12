module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;

    always @(posedge clk) begin
        a_prev <= a;
    end

    assign rise = (~a_prev) & a;
    assign down = a_prev & (~a);

endmodule