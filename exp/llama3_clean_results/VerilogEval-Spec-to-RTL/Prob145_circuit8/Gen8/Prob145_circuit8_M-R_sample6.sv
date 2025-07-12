module TopModule(
    input clock,
    input a,
    output p,
    output reg q
);

reg q_reg;

always @(posedge clock) begin
    p = a;
    if (a == 1'b1) begin
        q_reg = 1'b1;
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        q_reg = 1'b0;
    end
end

assign q = q_reg;

endmodule