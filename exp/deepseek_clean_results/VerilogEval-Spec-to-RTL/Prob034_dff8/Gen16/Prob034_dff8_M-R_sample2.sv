module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Single always block for synchronous behavior
always @(posedge clk) begin
    q <= d;  // Direct registered output update
end

endmodule