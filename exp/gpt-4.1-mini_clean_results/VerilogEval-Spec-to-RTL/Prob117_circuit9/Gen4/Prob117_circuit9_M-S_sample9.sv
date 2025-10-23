module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) 
        q <= a ? 3'd4 : (q == 3'd6 ? 3'd0 : q + 3'd1);

endmodule