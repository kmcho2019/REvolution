module TopModule (
    input  clock,
    input  a,
    output p,
    output q
);

reg q_reg;

assign p = clock & a;

always @(posedge clock) begin
    if(a) begin
        q_reg <= 1'b1;
    end else begin
        q_reg <= q_reg;
    end
end

always @(negedge clock) begin
    if(a) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

initial begin
    q_reg = 1'b0;
end

endmodule