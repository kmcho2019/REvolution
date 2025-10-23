module TopModule(
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

reg [15:0] reg_q;

always @(posedge clk) begin
    if (~resetn) begin
        reg_q <= 16'b0;
    end else begin
        if (byteena[0]) begin
            reg_q[7:0] <= d[7:0];
        end
        if (byteena[1]) begin
            reg_q[15:8] <= d[15:8];
        end
    end
end

assign q = reg_q;

endmodule