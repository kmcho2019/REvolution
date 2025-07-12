module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire mux_out;
    reg Q_reg;

    // 2:1 mux selecting r_in when L=1 else q_in
    assign mux_out = L ? r_in : q_in;

    // D flip-flop capturing mux output on posedge clk
    always @(posedge clk) begin
        Q_reg <= mux_out;
    end

    assign Q = Q_reg;

endmodule