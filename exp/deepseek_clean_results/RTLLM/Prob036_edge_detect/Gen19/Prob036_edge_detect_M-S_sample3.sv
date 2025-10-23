module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;

    always @(posedge clk) begin
        a_prev <= a;
        rise <= a & ~a_prev;
        down <= ~a & a_prev;
    end

endmodule