module TopModule(
    input  logic clock,
    input  logic a,
    output logic p,
    output logic q
);

logic p_reg;
logic q_reg;

always_ff @(posedge clock) begin
    if (a) begin
        p_reg <= 1;
    end else begin
        p_reg <= 0;
    end
end

always_ff @(negedge clock) begin
    if (p_reg) begin
        q_reg <= 1;
    end else if (~a) begin
        q_reg <= 0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule