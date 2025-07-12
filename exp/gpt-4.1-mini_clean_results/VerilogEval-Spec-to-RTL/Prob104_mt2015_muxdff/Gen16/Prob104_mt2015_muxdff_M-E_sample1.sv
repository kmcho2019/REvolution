module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire mux_out;
    reg Q_reg;

    // 2:1 Multiplexer selecting between r_in and q_in based on L
    assign mux_out = L ? r_in : q_in;

    // D flip-flop capturing mux_out at positive clock edge
    always @(posedge clk) begin
        Q_reg <= mux_out;
    end

    assign Q = Q_reg;

endmodule