module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire mux_out;

    // Combinational 2:1 MUX
    assign mux_out = L ? r_in : q_in;

    // D Flip-Flop capturing mux output on rising edge of clk
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule