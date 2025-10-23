module TopModule #(
    parameter POS = 0  // 0=LSB, 1=middle, 2=MSB
)(
    input clk,
    input L,
    input q_in,  // Previous state of required bit for feedback
    input r_in,   // Load value
    output reg Q  // Current state
);

    // Feedback selection logic based on position
    wire feedback = (POS == 2) ? (q_in ^ Q) :  // MSB: q[1] ^ q[2]
                   (POS == 1) ? q_in :        // Middle: q[0]
                   q_in;                      // LSB: q[2]

    // Mux for load/shift selection
    wire next_state = L ? r_in : feedback;

    // D flip-flop for storage
    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule