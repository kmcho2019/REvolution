module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Optimized 2:1 MUX using ternary operator
    wire mux_out = L ? r_in : q_in;

    // Embedded D Flip-Flop with non-blocking assignment
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule