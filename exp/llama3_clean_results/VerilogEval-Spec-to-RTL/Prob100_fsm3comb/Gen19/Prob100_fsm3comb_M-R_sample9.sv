module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Use conditional operators to directly implement the state transition logic
    assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :
                        (state == 2'b01) ? (in ? 2'b01 : 2'b10) :
                        (state == 2'b10) ? (in ? 2'b11 : 2'b00) :
                        (state == 2'b11) ? (in ? 2'b01 : 2'b10) : 2'b00;

    // Directly determine the output based on the current state
    assign out = (state == 2'b11) ? 1'b1 : 1'b0;

    // Alternatively, for a more explicit case-like structure in a single assign statement
    // assign next_state = (in && state == 2'b00) ? 2'b01 :
    //                     (!in && state == 2'b00) ? 2'b00 :
    //                     (in && state == 2'b01) ? 2'b01 :
    //                     (!in && state == 2'b01) ? 2'b10 :
    //                     (in && state == 2'b10) ? 2'b11 :
    //                     (!in && state == 2'b10) ? 2'b00 :
    //                     (in && state == 2'b11) ? 2'b01 :
    //                     (!in && state == 2'b11) ? 2'b10 : 2'b00;

endmodule