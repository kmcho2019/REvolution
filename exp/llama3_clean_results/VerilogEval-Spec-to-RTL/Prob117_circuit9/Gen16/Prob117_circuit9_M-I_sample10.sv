module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) 
        q <= 4; 
    else 
        q <= (q < 5) ? q + 1 : 0;
end

endmodule