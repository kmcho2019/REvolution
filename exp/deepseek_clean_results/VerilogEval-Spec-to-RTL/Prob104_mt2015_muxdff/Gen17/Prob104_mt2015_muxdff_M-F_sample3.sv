module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    // 2:1 MUX implementation
    wire mux_out = L ? r_in : q_in;

    // D Flip-Flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule