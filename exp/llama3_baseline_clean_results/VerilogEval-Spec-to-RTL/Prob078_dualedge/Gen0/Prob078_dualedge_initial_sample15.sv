module TopModule(
    input clk,
    input d,
    output q
);

reg q_int;
reg clk_prev;

always @(posedge clk) begin
    clk_prev <= 1'b1;
end

always @(negedge clk) begin
    clk_prev <= 1'b0;
end

always @(posedge clk or negedge clk) begin
    if (clk == 1'b1 && clk_prev == 1'b0) begin // rising edge
        q_int <= d;
    end else if (clk == 1'b0 && clk_prev == 1'b1) begin // falling edge
        q_int <= d;
    end
end

assign q = q_int;

endmodule