module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

wire [3:0] next_q = (q < 4'd9) ? (q + 4'd1) : 4'd0;

always @(posedge clk) begin
    if (reset) 
        q <= 4'd0;            // synchronous active-high reset
    else 
        q <= next_q;          // increment modulo 10
end

endmodule