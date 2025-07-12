module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire mux_out;
    reg ff_out;

    // 2:1 multiplexer implementation
    assign mux_out = L ? r_in : q_in;

    // D flip-flop implementation
    always @(posedge clk) begin
        ff_out <= mux_out;
    end

    assign Q = ff_out;

endmodule