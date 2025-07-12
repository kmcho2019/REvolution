module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_dly;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    assign rise =  a & ~a_dly; // 0->1 edge
    assign down = ~a &  a_dly; // 1->0 edge

endmodule