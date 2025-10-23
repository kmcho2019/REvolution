module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous values of the input vector

// Initialize the previous values register
initial begin
    prev_in = 8'b0;
end

// Sequential logic to update the previous values register and output
always @(posedge clk) begin
    anyedge <= (in ^ prev_in);  // XOR operation to detect edges
    prev_in <= in;  // Update the previous values register
end

endmodule