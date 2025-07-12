module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input q_in,     // For load operation
    input r_in,     // For load operation
    input q0,       // Current state of position 0
    input q1,       // Current state of position 1
    input q2,       // Current state of position 2
    output reg Q
);

    wire next_state;

    // Position-specific next state logic
    assign next_state = L ? r_in : 
                       (POSITION == 0) ? (q1 ^ q2) :  // XOR of q1 and q2
                       (POSITION == 1) ? q0 :         // Shift from position 0
                       q2;                            // Hold current value

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule