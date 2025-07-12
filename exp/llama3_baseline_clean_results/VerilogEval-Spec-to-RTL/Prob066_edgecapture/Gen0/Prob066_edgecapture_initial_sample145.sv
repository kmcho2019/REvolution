module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] captured;
reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        captured <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        prev_in <= in;
        captured <= captured | (~in & prev_in);
    end
end

assign out = captured;

endmodule