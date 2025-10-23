module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    wire next_state;
    
    // Next state logic (combinational)
    assign next_state = areset ? B : 
                       (state == A) ? (in ? A : B) :
                       (state == B) ? (in ? B : A) : B;
    
    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output logic remains the same
    assign out = (state == B);
    
endmodule