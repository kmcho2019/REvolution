module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Next-state values for each state and input combination
    wire next_state_a, next_state_b, next_state_c, next_state_d, next_state_e, next_state_f;
    
    // State A transitions
    assign next_state_a = (y[0] & ~w) ? 6'b000010 : (y[0] & w) ? 6'b000001 : 6'b000000;
    
    // State B transitions
    assign next_state_b = (y[1] & ~w) ? 6'b000100 : (y[1] & w) ? 6'b001000 : 6'b000000;
    
    // State C transitions
    assign next_state_c = (y[2] & ~w) ? 6'b010000 : (y[2] & w) ? 6'b001000 : 6'b000000;
    
    // State D transitions
    assign next_state_d = (y[3] & ~w) ? 6'b100000 : (y[3] & w) ? 6'b000001 : 6'b000000;
    
    // State E transitions
    assign next_state_e = (y[4] & w) ? 6'b010000 : (y[4] & ~w) ? 6'b001000 : 6'b000000;
    
    // State F transitions
    assign next_state_f = (y[5] & w) ? 6'b000100 : (y[5] & ~w) ? 6'b001000 : 6'b000000;
    
    // Multiplexers to select the correct next-state value
    assign Y1 = (y[0] & next_state_a[0]) | (y[1] & next_state_b[0]) | (y[2] & next_state_c[0]) | (y[3] & next_state_d[0]) | (y[4] & next_state_e[0]) | (y[5] & next_state_f[0]);
    assign Y2 = (y[0] & next_state_a[1]) | (y[1] & next_state_b[1]) | (y[2] & next_state_c[1]) | (y[3] & next_state_d[1]) | (y[4] & next_state_e[1]) | (y[5] & next_state_f[1]);
    assign Y3 = (y[0] & next_state_a[3]) | (y[1] & next_state_b[3]) | (y[2] & next_state_c[3]) | (y[3] & next_state_d[3]) | (y[4] & next_state_e[3]) | (y[5] & next_state_f[3]);
    assign Y4 = (y[0] & next_state_a[2]) | (y[1] & next_state_b[2]) | (y[2] & next_state_c[2]) | (y[3] & next_state_d[2]) | (y[4] & next_state_e[2]) | (y[5] & next_state_f[2]);

endmodule