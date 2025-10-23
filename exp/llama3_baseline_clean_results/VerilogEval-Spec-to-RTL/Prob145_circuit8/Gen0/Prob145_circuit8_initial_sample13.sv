module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
assign q = q_reg;

always @ (posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            q_reg <= 1'b1;
        end
    end else begin
        if (a) begin
            p <= 1'b1;
        end else begin
            p <= 1'b0;
        end
    end
end

always @ (posedge clock) begin
    if (~a) begin
        p <= 1'b0;
    end
end

initial begin
    q_reg <= 1'b0;
    p <= 1'b0;
end

endmodule