module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit input (for shift mode)
    input r_in,     // Load value input
    input fb0,      // Feedback input 0
    input fb1,      // Feedback input 1
    output Q
);

    parameter MODE = 0; // 0: XOR feedback (for q[0]), 1: direct (for q[1]), 2: self (for q[2])
    reg q;
    wire feedback;
    
    // Select appropriate feedback based on mode
    assign feedback = (MODE == 0) ? (fb0 ^ fb1) :  // XOR for bit 0
                     (MODE == 1) ? fb0 :           // Direct for bit 1
                     q;                            // Self for bit 2
    
    // Mux and flip-flop
    always @(posedge clk) begin
        q <= L ? r_in : feedback;
    end
    
    assign Q = q;

endmodule