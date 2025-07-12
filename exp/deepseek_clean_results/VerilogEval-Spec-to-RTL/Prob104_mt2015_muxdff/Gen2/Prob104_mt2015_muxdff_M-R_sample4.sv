module TopModule (
    input clk,
    input L,
    input q_in,       // Feedback input from other instances
    input r_in,       // Load value input
    output reg Q      // Output register
);

    wire mux_out;

    // 2:1 MUX
    assign mux_out = L ? r_in : q_in;

    // D Flip-Flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule