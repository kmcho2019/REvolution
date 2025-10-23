module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in; // Register to store the previous input value

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0; // Reset the output register
        prev_in <= 32'd0; // Reset the previous input register
    end else begin
        out <= out | (~in & prev_in); // Update the output register
        prev_in <= in; // Update the previous input register
    end
end

endmodule