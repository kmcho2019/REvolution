module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_int;

always @(posedge clk) begin
    if (shift_ena) begin
        q_int <= {data, q_int[3:1]};
    end else if (count_ena) begin
        q_int <= q_int - 1;
    end
end

assign q = q_int;

endmodule