module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d;  // Each of the 8 bits in d is stored in its corresponding q bit
end

endmodule