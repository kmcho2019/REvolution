module TopModule (
    input  clock,
    input  a,
    output p,
    output q
);

reg q_reg;
reg q_next;

always @(posedge clock) begin
    q_reg <= q_next;
end

always @(*) begin
    p = a & clock;
    if (~clock) begin
        if (a) begin
            q_next = q_reg;
        end else begin
            q_next = 0;
        end
    end else begin
        if (a & ~q_reg) begin
            q_next = 0;
        end else if (~a & q_reg) begin
            q_next = q_reg;
        end else if (a & q_reg) begin
            q_next = q_reg;
        end else begin
            q_next = 0;
        end
    end
end

assign q = q_reg;

initial begin
    q_reg = 0;
end

endmodule