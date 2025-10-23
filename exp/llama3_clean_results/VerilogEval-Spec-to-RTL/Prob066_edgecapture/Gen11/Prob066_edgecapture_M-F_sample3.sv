module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        prev_in <= in;
        // Set a bit in out_reg if the corresponding bit in in transitions from 1 to 0
        // Preserve previously set bits by using a bitwise OR with the current out_reg
        out_reg <= out_reg | (~in & prev_in);
    end
end

assign out = out_reg;

endmodule