module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_posedge;
reg q_negedge;

always @(posedge clk) begin
    q_posedge <= d;
end

always @(negedge clk) begin
    q_negedge <= d;
end

always @(*) begin
    q <= (q_posedge && ~q_negedge) ? d : q_negedge;
    if (~clk) begin
        q <= q_negedge;
    end else begin
        q <= q_posedge;
    end
end

endmodule