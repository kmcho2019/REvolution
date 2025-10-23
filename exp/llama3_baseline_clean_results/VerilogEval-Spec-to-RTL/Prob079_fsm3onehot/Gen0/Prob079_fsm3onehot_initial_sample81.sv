module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
assign next_state = 
    (state == 4'b0001) ? (in == 0 ? 4'b0001 : 4'b0010) : // A
    (state == 4'b0010) ? (in == 0 ? 4'b0100 : 4'b0010) : // B
    (state == 4'b0100) ? (in == 0 ? 4'b0001 : 4'b1000) : // C
    (state == 4'b1000) ? (in == 0 ? 4'b0100 : 4'b0010) ; // D

// Output logic
assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule