module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

// Next state logic using nested ternary operators
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) : // A
                    (state == 2'b01) ? (in ? 2'b01 : 2'b10) : // B
                    (state == 2'b10) ? (in ? 2'b11 : 2'b00) : // C
                    (state == 2'b11) ? (in ? 2'b01 : 2'b10) : // D
                    2'b00; // default

// Output logic for Moore machine: output depends only on current state
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule