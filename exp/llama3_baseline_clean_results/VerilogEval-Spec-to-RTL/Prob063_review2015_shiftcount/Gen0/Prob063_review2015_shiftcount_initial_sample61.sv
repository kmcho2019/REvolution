module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (shift_ena) begin
        q[3:0] = {data, q[3:1]};
    end else if (count_ena) begin
        if (q == 0) begin
            q[3:0] = 0;
        end else begin
            q[3:0] = q - 1;
        end
    end
end

endmodule