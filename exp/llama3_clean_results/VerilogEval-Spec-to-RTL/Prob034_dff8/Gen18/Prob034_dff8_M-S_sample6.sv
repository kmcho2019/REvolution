module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d; // Directly assign all bits of d to q
end

endmodule