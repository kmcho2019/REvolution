module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

// Detect transitions from 1 to 0 in a combinational manner
wire [31:0] transition_detected;
assign transition_detected = (~in) & prev_in;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'b0;
        prev_in <= in; // Reset previous input to current input to avoid false transitions at reset
    end else begin
        // Update output register based on detected transitions
        out_reg <= out_reg | transition_detected;
        // Update previous input
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule