module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 4;

always @(posedge clk) begin
    if (a) 
        q <= 4; 
    else 
        q <= (q < 6) ? q + 1 : 0;
end

endmodule