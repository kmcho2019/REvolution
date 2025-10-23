module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    input feedback_en,  // Additional control for feedback path
    input feedback_bit, // Additional input for feedback configuration
    output reg Q
);

    wire next_state;
    
    // Combined load/feedback logic
    assign next_state = L ? r_in : 
                      (feedback_en ? (q_in ^ feedback_bit) : q_in);
    
    // Sequential element
    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule