module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg Q_reg;

    always @(posedge clk) begin
        if (L) begin
            Q_reg <= r_in;
        end else begin
            Q_reg <= q_in;
        end
    end

    assign Q = Q_reg;

endmodule