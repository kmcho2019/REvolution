module TopModule(
    input           clk,
    input   [7:0]   in,
    output  [7:0]   anyedge
);

reg [7:0] prev_in; // Register to store the previous input
reg [7:0] anyedge_reg; // Register for the output

always @(posedge clk) begin
    prev_in <= in; // Store the current input as previous input at the next clock
    anyedge_reg <= (in ^ prev_in); // Detect any edge and store the result
end

assign anyedge = anyedge_reg; // Continuous assignment for output

initial begin
    prev_in = 8'b0; // Initialize previous input to 0
    anyedge_reg = 8'b0; // Initialize output register to 0
end

endmodule