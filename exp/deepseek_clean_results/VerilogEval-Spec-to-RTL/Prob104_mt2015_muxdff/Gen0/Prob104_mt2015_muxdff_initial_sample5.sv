module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q_reg;
    wire mux_out;

    // 2:1 multiplexer
    assign mux_out = L ? r_in : q_in;

    // D flip-flop
    always @(posedge clk) begin
        q_reg <= mux_out;
    end

    assign Q = q_reg;

endmodule