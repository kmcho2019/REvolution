module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        q_reg <= 1;
    end else if (clock && ~a) begin
        q_reg <= 0;
    end
end

assign p = (clock && a);

endmodule