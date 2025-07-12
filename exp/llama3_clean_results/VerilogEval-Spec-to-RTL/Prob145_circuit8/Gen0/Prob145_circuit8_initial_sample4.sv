module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg = 0;

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q_reg <= 1;
    end
end

assign q = q_reg;
assign p = (clock && a);

endmodule