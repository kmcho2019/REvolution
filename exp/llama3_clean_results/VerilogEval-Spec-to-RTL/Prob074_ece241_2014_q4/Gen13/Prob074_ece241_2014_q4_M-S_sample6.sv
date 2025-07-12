module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] ff_out = 3'b000;

always @(posedge clk) begin
    ff_out[0] <= x ^ ff_out[0];
    ff_out[1] <= x & ~ff_out[1];
    ff_out[2] <= x | ~ff_out[2];
end

assign z = ~(ff_out[0] | ff_out[1] | ff_out[2]);

endmodule