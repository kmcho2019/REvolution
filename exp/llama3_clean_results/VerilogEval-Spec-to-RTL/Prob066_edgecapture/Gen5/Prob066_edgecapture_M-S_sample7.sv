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
        out_reg <= 0;
        prev_in <= 0;
    end else begin
        // Detect transitions from 1 to 0
        out_reg <= out_reg | (~in & prev_in);
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule