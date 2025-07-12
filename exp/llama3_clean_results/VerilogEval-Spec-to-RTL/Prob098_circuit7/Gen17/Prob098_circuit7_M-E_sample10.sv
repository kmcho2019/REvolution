module TopModule(
    input clk,
    input a,
    output reg q
);

reg current_state;

always @(posedge clk) 
    if (a)
        current_state <= ~current_state;
    else
        current_state <= current_state;

assign q = current_state;

endmodule