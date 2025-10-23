module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is high only in state D (11)
assign out = (state == 2'b11);

// State transition logic using conditional operator
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // A
                   (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // B
                   (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // C
                                      (in ? 2'b01 : 2'b10);   // D

endmodule