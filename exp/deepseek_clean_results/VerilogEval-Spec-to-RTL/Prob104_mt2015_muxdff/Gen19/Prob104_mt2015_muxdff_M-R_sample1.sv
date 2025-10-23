module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input
    input r_in,    // Parallel load input
    output reg Q   // Output register
);

    // Combined mux and flip-flop in one always block
    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule