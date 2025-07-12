module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

always @(posedge clk) begin
    q <= d;
end

// Explicitly initialize q to avoid any potential issues, though in a real-world scenario,
// this would depend on the specific requirements of the design and the technology used.
initial begin
    q = 8'b0;
end

endmodule