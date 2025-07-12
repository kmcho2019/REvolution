module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q = 8'b0 // Initialize 'q' to zero
);

always @(posedge clk) begin
    q <= d; // Update 'q' with 'd' at the positive edge of the clock
end

endmodule