module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;

initial q_reg = 1'b0;

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(posedge clock or negedge clock) begin
    if (clock && a) begin
        q_reg <= 1'b1;
    end else if (!clock && a) begin
        q_reg <= 1'b0;
    end
end

assign p = (a && clock);
assign q = q_reg;

endmodule