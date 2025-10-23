module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions for clarity
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= state ? in : ~in;  // Efficient state transition logic
    end

    assign out = state;  // Direct output assignment

endmodule