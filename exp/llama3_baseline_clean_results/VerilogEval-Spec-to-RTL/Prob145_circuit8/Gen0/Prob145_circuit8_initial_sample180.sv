module TopModule(
    input  clock,
    input  a,
    output p,
    output reg q
);

reg p_reg;

always @(*) begin
    p = a;
end

always @(posedge clock) begin
    p_reg <= a;
end

always @(posedge clock or negedge clock) begin
    if (clock == 1) begin
        if (a == 1) begin
            q <= q;
        end else begin
            q <= 0;
        end
    end else begin
        q <= 1;
    end
end

endmodule