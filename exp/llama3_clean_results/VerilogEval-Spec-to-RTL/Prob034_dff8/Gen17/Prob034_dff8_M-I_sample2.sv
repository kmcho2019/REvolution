module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    // Assign the value of 'd' to 'q' at each positive edge of the clock
    q <= d;
end

endmodule