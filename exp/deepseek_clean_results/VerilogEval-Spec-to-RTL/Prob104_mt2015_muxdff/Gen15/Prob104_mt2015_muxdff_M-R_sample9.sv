module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value (feedback)
    input r_in,     // Load value
    output reg Q    // Output register
);

    // Mux selects between load and feedback
    wire next_Q = L ? r_in : q_in;

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule