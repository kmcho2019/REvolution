module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    assign rise = (~a_d) & a;
    assign down = a_d & (~a);

endmodule