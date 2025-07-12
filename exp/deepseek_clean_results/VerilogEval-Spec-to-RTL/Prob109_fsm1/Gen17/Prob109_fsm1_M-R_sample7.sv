module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state; // 0=A, 1=B
    wire next_state;

    // State transition logic
    assign next_state = areset ? 1'b1 :  // Async reset to B
                       state ? in :      // If in B: 1->B, 0->A
                       ~in;              // If in A: 1->A, 0->B

    // State register
    always @(posedge clk or posedge areset) begin
        state <= next_state;
    end

    // Output assignment
    assign out = state;
    
endmodule