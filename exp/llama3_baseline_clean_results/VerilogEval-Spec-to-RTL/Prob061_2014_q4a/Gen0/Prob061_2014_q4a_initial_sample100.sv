module TopModule(clk, w, R, E, L, Q);
    input clk;
    input w;
    input R;
    input E;
    input L;
    output Q;

    reg Q_reg;

    always @(posedge clk) begin
        if (L) begin
            Q_reg <= R;
        end else if (E) begin
            Q_reg <= w;
        end
    end

    assign Q = Q_reg;

endmodule