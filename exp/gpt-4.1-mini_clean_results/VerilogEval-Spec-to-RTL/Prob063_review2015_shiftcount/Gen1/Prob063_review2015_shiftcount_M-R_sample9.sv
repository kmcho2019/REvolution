module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] q_next;

always @(*) begin
    if (shift_ena) begin
        q_next = {data, q[3:1]};
    end else if (count_ena) begin
        q_next = q - 1'b1;
    end else begin
        q_next = q;
    end
end

always @(posedge clk) begin
    q <= q_next;
end

endmodule