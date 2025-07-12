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
        lfsr <= (lfsr + 1) % 1000;
    end
end

assign q = lfsr;

endmodule