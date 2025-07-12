module TopModule #(
    parameter POSITION = 0
) (
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
    
    // Position-specific feedback logic
    wire feedback;
    generate
        if (POSITION == 0) begin
            assign feedback = q1 ^ q2;  // Bit 0 logic
        end else if (POSITION == 1) begin
            assign feedback = q0;       // Bit 1 logic
        end else begin
            assign feedback = q2;      // Bit 2 logic
        end
    endgenerate
    
    // Mux to select between load and feedback
    assign next_state = L ? r_in : feedback;

    // D-flipflop
    reg state;
    always @(posedge clk) begin
        state <= next_state;
    end
    
    assign Q = state;

endmodule