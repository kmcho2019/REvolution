module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 10'd0;
    end else begin
        lfsr <= (lfsr == 10'd999) ? 10'd0 : lfsr + 10'd1;
    end
end

assign q = lfsr;

endmodule