module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] d_ff;

always @(posedge clk) begin
    if (~resetn) begin
        d_ff <= 4'b0000;
    end else begin
        d_ff <= {d_ff[2:0], in};
    end
end

assign out = d_ff[3];

endmodule