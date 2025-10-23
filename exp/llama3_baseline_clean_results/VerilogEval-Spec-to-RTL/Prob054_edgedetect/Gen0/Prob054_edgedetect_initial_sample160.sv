module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Previous input value

// Detect positive edge for each bit in the input vector
always @(posedge clk) begin
    prev_in <= in; // Update previous input value
end

// Generate output
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] = in[i] && !prev_in[i]; // Set output to 1 when positive edge is detected
    end
end

endmodule