module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire mux_out;

    // 2:1 multiplexer selecting input based on L
    assign mux_out = L ? r_in : q_in;

    // Flip-flop capturing the mux output on rising edge of clk
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule