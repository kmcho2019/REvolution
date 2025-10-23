module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

// Combinational logic to detect change from 1 to 0
wire [31:0] change_detect;
assign change_detect = (~in) & prev_in;

always @(posedge clk) begin
    // Check if reset is asserted
    if (reset) begin
        // Reset the output register
        out_reg <= 32'b0;
        prev_in <= 32'b0; // Reset previous input
    end else begin
        // Update the output register based on the detected changes
        out_reg <= out_reg | change_detect;
        // Store the current input as the previous input for the next clock cycle
        prev_in <= in;
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule