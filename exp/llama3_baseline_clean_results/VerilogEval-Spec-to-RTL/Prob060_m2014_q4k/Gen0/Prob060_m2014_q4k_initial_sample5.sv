module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] q;

always @(posedge clk) begin
    if (~resetn) begin
        q <= 4'b0000;
    end else begin
        q[0] <= in;
        q[1] <= q[0];
        q[2] <= q[1];
        q[3] <= q[2];
    end
end

assign out = q[3];

endmodule