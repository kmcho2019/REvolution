module TopModule (
    input clk,
    input L,
    input q_in,     // Serial input/feedback
    input r_in,     // Parallel load input
    output reg Q    // Current state output
);

    wire next_state = L ? r_in : (Q ^ q_in);

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule