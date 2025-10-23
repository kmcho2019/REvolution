module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire mux_out;
    reg q_reg;

    // 2:1 mux
    assign mux_out = L ? r_in : q_in;

    // Clock-gated flip-flop implementation
    assign Q = q_reg;
    always @(posedge clk) q_reg <= mux_out;

endmodule