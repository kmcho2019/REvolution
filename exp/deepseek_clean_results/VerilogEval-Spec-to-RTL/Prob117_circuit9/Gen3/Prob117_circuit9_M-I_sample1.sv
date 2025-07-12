module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100  // Initialize to 4
);

always @(posedge clk) begin
    q <= a ? q : (q + 1) % 7;  // Hold when a=1, increment mod7 when a=0
end

endmodule