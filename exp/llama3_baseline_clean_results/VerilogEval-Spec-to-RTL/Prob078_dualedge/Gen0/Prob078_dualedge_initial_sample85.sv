module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_posedge;
reg q_negedge;
reg prev_clk;

always @(posedge clk) begin
    q_posedge <= d;
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q_negedge <= d;
    prev_clk <= 1'b0;
end

always @(*) begin
    if (prev_clk) begin
        q <= q_posedge;
    end else begin
        q <= q_negedge;
    end
end

endmodule