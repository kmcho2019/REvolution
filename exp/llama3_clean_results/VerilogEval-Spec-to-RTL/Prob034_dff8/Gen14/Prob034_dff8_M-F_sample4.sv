module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q = d; // Using blocking assignment for clarity, though in this context, both blocking and non-blocking would work
end

endmodule