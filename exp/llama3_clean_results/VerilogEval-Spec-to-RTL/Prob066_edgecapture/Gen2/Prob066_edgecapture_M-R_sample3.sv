module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'b0;
        prev_in <= 32'b0;
    end else begin
        // First, calculate the new output based on the current previous input and current input
        out_reg <= out_reg | (~in & prev_in);
        // Then, update the previous input for the next cycle
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule