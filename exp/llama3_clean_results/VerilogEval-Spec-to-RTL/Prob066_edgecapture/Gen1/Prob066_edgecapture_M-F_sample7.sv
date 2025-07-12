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
    end else begin
        // Update the output register based on the change from 1 to 0
        out_reg <= out_reg | (~in & prev_in);
    end
    
    // Store the current input as the previous input for the next clock cycle
    prev_in <= in;
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule