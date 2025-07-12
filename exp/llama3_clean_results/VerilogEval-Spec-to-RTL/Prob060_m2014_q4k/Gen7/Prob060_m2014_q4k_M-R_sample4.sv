module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] q;
wire [3:0] d;

assign d[0] = in;
assign d[1] = q[0];
assign d[2] = q[1];
assign d[3] = q[2];

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'd0;
    end else begin
        q <= d;
    end
end

assign out = q[3];

endmodule