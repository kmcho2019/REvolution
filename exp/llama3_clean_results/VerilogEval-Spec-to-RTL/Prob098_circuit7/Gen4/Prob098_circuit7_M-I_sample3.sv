module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Explicit initial state to match simulation
);

always @(posedge clk) begin
    q <= ~a; // Direct and simple logic, utilizing non-blocking assignment
end

endmodule