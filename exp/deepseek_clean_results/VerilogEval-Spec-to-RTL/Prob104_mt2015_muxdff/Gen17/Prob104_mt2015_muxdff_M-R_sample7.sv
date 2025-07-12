module TopModule (
    input clk,
    input L,
    input q_in,     // Current state of this bit
    input r_in,     // Load value
    input q0,       // Value of q[0] (for bits 1 and 2)
    input q1,       // Value of q[1] (for bits 0 and 2)
    input q2,       // Value of q[2] (for bit 0)
    output Q
);

    wire next_state;
    
    // Feedback logic:
    // For bit 0: q1 ^ q2
    // For bit 1: q0
    // For bit 2: q1
    assign next_state = L ? r_in : 
                      (q_in == q0) ? (q1 ^ q2) :  // Bit 0 case
                      (q_in == q1) ? q0 :         // Bit 1 case
                      q1;                         // Bit 2 case

    // D-flipflop
    reg state;
    always @(posedge clk) begin
        state <= next_state;
    end
    
    assign Q = state;

endmodule