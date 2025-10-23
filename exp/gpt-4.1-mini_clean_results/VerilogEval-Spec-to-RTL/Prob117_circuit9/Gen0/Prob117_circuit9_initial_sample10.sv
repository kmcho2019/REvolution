module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a)
        q <= 3'b100;         // q=4 when a=1
    else
        q <= q + 1'b1;       // increment q modulo 8 when a=0
end

endmodule