module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] d_ff;

always @(posedge clk) begin
    if (~resetn) begin
        d_ff <= 4'd0;
    end else begin
        d_ff[0] <= in;
        d_ff[1] <= d_ff[0];
        d_ff[2] <= d_ff[1];
        d_ff[3] <= d_ff[2];
    end
end

assign out = d_ff[3];

endmodule