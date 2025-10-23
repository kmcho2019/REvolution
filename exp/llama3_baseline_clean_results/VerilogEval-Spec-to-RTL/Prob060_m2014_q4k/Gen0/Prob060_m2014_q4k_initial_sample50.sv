module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

reg [3:0] d_flops;

always @(posedge clk) begin
    if (!resetn) begin
        d_flops <= 4'd0;
    end else begin
        d_flops <= {in, d_flops[3:1]};
    end
end

assign out = d_flops[0];

endmodule