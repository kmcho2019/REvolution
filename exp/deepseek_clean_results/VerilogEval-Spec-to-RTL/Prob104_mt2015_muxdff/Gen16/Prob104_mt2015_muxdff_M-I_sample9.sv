module TopModule (
    input  clk,    // Clock input
    input  L,      // Load control (1 = load from r_in, 0 = load from q_in)
    input  q_in,   // Feedback input (from previous state)
    input  r_in,   // Load value input
    output reg Q    // Registered output
);

// Synchronous loadable flip-flop with 2:1 input mux
always @(posedge clk) begin
    Q <= L ? r_in : q_in;
end

endmodule