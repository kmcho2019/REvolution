module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        if (q == 4'b0) begin
            q <= 4'b1111;
        end else begin
            q <= q - 1;
        end
    end
end

endmodule