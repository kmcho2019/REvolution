module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

always @(*) begin
    if (clk == 1'b1) begin
        q = q_pos;
    end else begin
        q = q_neg;
    end
end

endmodule