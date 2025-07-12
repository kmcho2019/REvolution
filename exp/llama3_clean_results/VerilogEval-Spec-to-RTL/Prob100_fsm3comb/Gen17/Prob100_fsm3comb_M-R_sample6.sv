module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

assign next_state = 
    (state == 2'b00 &&!in)? 2'b00 : // State A, in = 0
    (state == 2'b00 &&  in)? 2'b01 : // State A, in = 1
    (state == 2'b01 &&!in)? 2'b10 : // State B, in = 0
    (state == 2'b01 &&  in)? 2'b01 : // State B, in = 1
    (state == 2'b10 &&!in)? 2'b00 : // State C, in = 0
    (state == 2'b10 &&  in)? 2'b11 : // State C, in = 1
    (state == 2'b11 &&!in)? 2'b10 : // State D, in = 0
    (state == 2'b11 &&  in)? 2'b01 : // State D, in = 1
    2'b00; // Default state

assign out = (state == 2'b11); // Output is 1 only in state D

endmodule