module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

// Sequential logic to update registers
always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'b0;
        prev_in <= 32'b0;
    end else begin
        prev_in <= in;
        out_reg <= out_reg | (~in & prev_in);
    end
end

// Combinational logic to assign output
assign out = out_reg;

endmodule