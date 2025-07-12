module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] count;

always @(posedge clk)
    if (reset) 
        count <= 4'd0;
    else if (count == 4'd15) 
        count <= 4'd0;
    else 
        count <= count + 1'b1;

assign q = count;

endmodule