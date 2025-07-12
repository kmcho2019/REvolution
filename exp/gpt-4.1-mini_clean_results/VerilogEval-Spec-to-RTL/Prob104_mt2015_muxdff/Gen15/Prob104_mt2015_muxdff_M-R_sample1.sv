module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire mux_out;
    reg  Q_reg;

    // 2:1 Mux selects between r_in (load) and q_in (feedback)
    assign mux_out = L ? r_in : q_in;

    // Flip-flop captures mux_out on rising clock edge
    always @(posedge clk) begin
        Q_reg <= mux_out;
    end

    // Output is driven by registered Q_reg
    assign Q = Q_reg;

endmodule