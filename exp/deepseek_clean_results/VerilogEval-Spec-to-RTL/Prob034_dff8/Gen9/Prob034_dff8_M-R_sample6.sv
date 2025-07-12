module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Single always block for all 8 DFFs
always @(posedge clk) begin
    q <= d;
end

endmodule