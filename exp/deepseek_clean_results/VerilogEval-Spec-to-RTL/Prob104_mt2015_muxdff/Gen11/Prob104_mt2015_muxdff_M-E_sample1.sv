module TopModule (
    input clk,
    input L,
    input q_in,      // Current state input (feedback)
    input r_in,      // Load value input
    input q_left,    // Left neighbor's state (q[1] for q[2] instance)
    input q_right,   // Right neighbor's state (q[2] for q[0] instance)
    output reg Q     // Registered output
);

    wire next_state = L ? r_in : 
                    (Q == q_left) ? q_right :  // Implements XOR: Q^q_left
                    ~q_right;                 // XOR alternative when Q != q_left

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule