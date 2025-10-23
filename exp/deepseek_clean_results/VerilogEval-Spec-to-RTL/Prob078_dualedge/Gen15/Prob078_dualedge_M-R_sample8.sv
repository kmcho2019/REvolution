module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_prev;
    wire clk_edge = (clk ^ clk_prev);

    always @(*) clk_prev <= clk;

    always @(*) 
        if (clk_edge) q <= d;

endmodule