module TopModule (
    input clk,
    input L,
    input q_in,       // Feedback input from other instances
    input r_in,       // Load value input
    output reg Q      // Output register
);

    // Pure combinatorial 2:1 MUX
    wire mux_out = L ? r_in : q_in;

    // Synchronous D Flip-Flop with non-blocking assignment
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule