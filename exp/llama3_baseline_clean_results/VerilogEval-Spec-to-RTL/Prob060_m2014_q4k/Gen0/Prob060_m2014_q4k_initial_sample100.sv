module TopModule(
    input           clk,
    input           resetn,
    input           in,
    output reg      out
);

reg [3:0] d_ff_out;

always @(posedge clk) begin
    if (~resetn) begin
        d_ff_out <= 4'b0000;
    end else begin
        d_ff_out[0] <= in;
        d_ff_out[1] <= d_ff_out[0];
        d_ff_out[2] <= d_ff_out[1];
        d_ff_out[3] <= d_ff_out[2];
    end
end

assign out = d_ff_out[3];

endmodule