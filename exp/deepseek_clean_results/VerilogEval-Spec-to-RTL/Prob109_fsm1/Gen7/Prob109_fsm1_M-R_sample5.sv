module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    wire state, next_state;
    
    // Next state logic (combinational)
    assign next_state = (state == A) ? (in ? A : B) :
                       (state == B) ? (in ? B : A) : B;
    
    // State register with async reset
    assign #1 state = areset ? B : (clk ? (clk ? next_state : state) : state);
    
    // Output logic
    assign out = (state == B);
    
endmodule