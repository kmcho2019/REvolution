module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;
reg clk_phase;

always @(posedge clk)
begin
    q_pos <= d;
    clk_phase <= 1'b1;
end

always @(negedge clk)
begin
    q_neg <= d;
    clk_phase <= 1'b0;
end

always @(posedge clk or negedge clk)
begin
    if(clk_phase)
        q <= q_pos;
    else
        q <= q_neg;
end

endmodule