module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_reg;
reg q_reg;

always @(posedge clock) begin
    p_reg <= a;
    q_reg <= a;
end

always @(negedge clock) begin
    if (!a) begin
        q_reg <= 0;
    end
end

assign p = p_reg && clock;
assign q = q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule