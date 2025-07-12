module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State A (0001) transitions
    wire next_A = (state == 4'b0001) ? (~in ? 1'b1 : 1'b0) : 1'b0;
    
    // State B (0010) transitions
    wire next_B = (state == 4'b0010) ? (in ? 1'b1 : 1'b0) : 
                 ((state == 4'b0001) & in) ? 1'b1 :
                 ((state == 4'b1000) & in) ? 1'b1 : 1'b0;
    
    // State C (0100) transitions
    wire next_C = (state == 4'b0100) ? (~in ? 1'b1 : 1'b0) : 
                 ((state == 4'b0010) & ~in) ? 1'b1 :
                 ((state == 4'b1000) & ~in) ? 1'b1 : 1'b0;
    
    // State D (1000) transitions
    wire next_D = (state == 4'b0100) & in ? 1'b1 : 1'b0;

    assign next_state = {next_D, next_C, next_B, next_A};
    assign out = state[3];

endmodule