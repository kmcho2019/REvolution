module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

always @(posedge clk) begin
    // Check if reset is asserted
    if (reset) begin
        // Reset the output register
        out_reg <= 32'b0;
        prev_in <= 32'b0; // Reset previous input
    end else begin
        // Store the current input as the previous input for the next clock cycle
        prev_in <= in;
        
        // Update the output register based on the detected changes
        // For each bit, if it was 1 in the previous cycle and is 0 now, set the corresponding bit in out_reg
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule