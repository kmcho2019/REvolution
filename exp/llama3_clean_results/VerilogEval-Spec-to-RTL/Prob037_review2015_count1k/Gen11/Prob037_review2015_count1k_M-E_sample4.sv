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
        lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[5] ^ lfsr[3] ^ lfsr[2]};
    end
end

assign q = lfsr;

endmodule