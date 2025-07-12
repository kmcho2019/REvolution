module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
    end else begin
        q[3] <= in;
        for (int i = 2; i >= 0; i--) begin
            q[i] <= q[i + 1];
        end
    end
end

assign out = q[0];

endmodule