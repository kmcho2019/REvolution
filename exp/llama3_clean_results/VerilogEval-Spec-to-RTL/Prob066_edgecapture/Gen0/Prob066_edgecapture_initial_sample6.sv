module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

always @(posedge clk) begin
    // Store the current input as the previous input for the next clock cycle
    prev_in <= in;
    
    // Check if reset is asserted
    if (reset) begin
        // Reset the output register
        out_reg <= 32'b0;
    end else begin
        // Iterate over each bit of the input
        for (int i = 0; i < 32; i++) begin
            // Check if the current bit of the input is 0 and the previous bit was 1
            if (~in[i] && prev_in[i]) begin
                // Set the corresponding bit in the output register to 1
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule