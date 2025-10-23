module edge_detect (
    input clk,
    input a,
    output rise,
    output down
);

    reg a_delayed;

    always @(posedge clk) begin
        a_delayed <= a;
    end

    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule