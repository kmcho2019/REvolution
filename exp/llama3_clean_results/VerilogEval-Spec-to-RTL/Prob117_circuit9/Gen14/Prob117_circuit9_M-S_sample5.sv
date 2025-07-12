module TopModule(
    input clk,
    input a,
    output reg [2:0] q = 4
);

always @(posedge clk) begin
    if (a) 
        q <= 4; 
    else 
        q <= (q == 5)? 0 : q + 1;
end

endmodule