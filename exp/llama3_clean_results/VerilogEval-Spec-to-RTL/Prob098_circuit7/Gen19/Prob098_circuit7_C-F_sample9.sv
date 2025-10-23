module TopModule(
    input clk,
    input a,
    output reg q = 1'b1
);

reg state = 1'b1;

always @(posedge clk) 
    if (a) 
        state <= 1'b0; 
    else 
        state <= 1'b1;

assign q = state;

endmodule