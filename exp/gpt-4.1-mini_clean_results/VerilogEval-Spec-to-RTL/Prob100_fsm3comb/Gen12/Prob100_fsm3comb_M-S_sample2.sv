module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Next state logic as a combinational expression using nested ternary operators
    assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) : 
                        (state == 2'b01) ? (in ? 2'b01 : 2'b10) : 
                        (state == 2'b10) ? (in ? 2'b11 : 2'b00) : 
                        (state == 2'b11) ? (in ? 2'b01 : 2'b10) : 2'b00;

    // Output logic depends only on state D (2'b11)
    assign out = (state == 2'b11);

endmodule