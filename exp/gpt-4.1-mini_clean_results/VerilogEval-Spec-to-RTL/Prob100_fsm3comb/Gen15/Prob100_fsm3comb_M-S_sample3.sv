module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Next state logic using nested ternary operators for compact combinational logic
    assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // A: B if in=1 else A
                        (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // B: B if in=1 else C
                        (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // C: D if in=1 else A
                        (state == 2'b11) ? (in ? 2'b01 : 2'b10) :  // D: B if in=1 else C
                        2'b00;                                     // default A

    // Output logic: 1 only in state D (2'b11)
    assign out = (state == 2'b11);

endmodule