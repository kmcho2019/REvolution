module TopModule(
    input clk,
    input d,
    output q
);

reg q_pos;
reg q_neg;
reg q_int;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

always @(*) begin
    if (clk) begin
        q_int = q_pos;
    end else begin
        q_int = q_neg;
    end
end

assign q = q_int;

endmodule