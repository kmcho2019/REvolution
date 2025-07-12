module TopModule(
    input  wire clock,
    input  wire a,
    output wire p,
    output wire q
);

reg p_reg;
reg q_reg;

assign p = p_reg;
assign q = q_reg;

always @(posedge clock) begin
    if (a) begin
        p_reg <= 1'b1;
    end else begin
        p_reg <= 1'b0;
    end
end

always @(negedge clock) begin
    if (p_reg) begin
        q_reg <= 1'b1;
    end else begin
        q_reg <= 1'b0;
    end
end

always @(posedge clock) begin
    if (~a) begin
        q_reg <= 1'b0;
    end
end

initial begin
    p_reg <= 1'b0;
    q_reg <= 1'b0;
end

endmodule