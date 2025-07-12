module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State wire (0=A, 1=B)
    wire state;
    
    // Next state logic with XOR
    wire next_state = state ^ ~in;

    // State feedback with async reset mux
    assign state = areset ? 1'b1 : 
                  (clk ? next_state : state);

    // Output is simply the state bit
    assign out = state;

endmodule