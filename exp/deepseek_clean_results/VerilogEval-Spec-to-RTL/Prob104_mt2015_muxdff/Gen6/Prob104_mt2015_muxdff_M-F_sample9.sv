module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit's value (for feedback)
    input r_in,     // Load value
    input q0,       // Bit 0 value (for feedback)
    input q1,       // Bit 1 value (for feedback)
    input q2,       // Bit 2 value (for feedback)
    output Q
);

    parameter BIT_POS = 0; // 0, 1, or 2 to indicate which bit this is
    reg q;
    wire feedback;
    wire mux_out;
    
    // Select appropriate feedback based on bit position
    assign feedback = (BIT_POS == 0) ? (q1 ^ q2) : 
                     (BIT_POS == 1) ? q0 : 
                     q2;
    
    assign mux_out = L ? r_in : feedback;
    
    always @(posedge clk) begin
        q <= mux_out;
    end
    
    assign Q = q;

endmodule