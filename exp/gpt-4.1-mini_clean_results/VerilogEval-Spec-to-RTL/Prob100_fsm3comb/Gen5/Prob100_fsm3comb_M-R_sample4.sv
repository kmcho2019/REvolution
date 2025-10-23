module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

// next_state logic based on state and in
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // A
                    (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // B
                    (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // C
                    (state == 2'b11) ? (in ? 2'b01 : 2'b10) :  // D
                    2'b00; // default

// output logic: 1 only in state D (2'b11), else 0
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule