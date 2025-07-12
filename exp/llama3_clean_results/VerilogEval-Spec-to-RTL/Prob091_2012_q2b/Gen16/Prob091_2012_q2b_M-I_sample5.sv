module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);
    // Assign Y1 based on the state machine's logic
    assign Y1 = w & y[0];
    
    // Assign Y3 considering the one-hot encoding and state transitions
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
endmodule