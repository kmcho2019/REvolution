module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q = '0  // Initialize q to all zeros
);

always_ff @(posedge clk) begin
    q <= d;  // Load d into q on the positive edge of clk
end

endmodule