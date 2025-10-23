module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_delayed = 1'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_delayed <= 1'b0;
        end else begin
            a_delayed <= a;
        end
    end

    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule