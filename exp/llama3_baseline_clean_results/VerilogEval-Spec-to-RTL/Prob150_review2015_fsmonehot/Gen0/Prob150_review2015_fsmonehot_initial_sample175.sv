module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Next state logic
    assign B3_next = (state[9:0] == 10'b0000010000) |  // Current state is B2
                     (state[9:0] == 10'b0000100000) & d;  // Current state is B3 and d=1 (but this case does not apply because B3 always goes to Count)
    
    assign S_next = (state[9:0] == 10'b1000000000) & !d |  // Current state is S and d=0
                    (state[9:0] == 10'b0000000010) & !d |  // Current state is S1 and d=0
                    (state[9:0] == 10'b0000001000) & !d |  // Current state is S110 and d=0
                    (state[9:0] == 10'b0000000001) & !d |  // This case does not apply
                    (state[9:0] == 10'b1000000000) & ack;  // Current state is Wait and ack=1
    
    assign S1_next = (state[9:0] == 10'b0000000001) & d;  // Current state is S and d=1
    
    assign Count_next = (state[9:0] == 10'b0000000100) & done_counting;  // Current state is Count and done_counting=1
    
    assign Wait_next = (state[9:0] == 10'b0000000100) & !done_counting |  // Current state is Count and done_counting=0
                       (state[9:0] == 10'b0000000001) & d & d & d & !d;  // This case does not apply
    
    // Output logic
    assign done = state[9:0] == 10'b0000000001;  // State is Wait (but Wait does not have d=1 in the diagram, only ack)
    
    assign counting = state[9:0] == 10'b0000100000;  // State is Count
    
    assign shift_ena = state[9:0] == 10'b0000010000 |  // State is B0
                       state[9:0] == 10'b0000100000 |  // State is B1
                       state[9:0] == 10'b0001000000 |  // State is B2
                       state[9:0] == 10'b0010000000;  // State is B3

endmodule