module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic
assign next_state = (state == 4'b0001) ? (in ? 4'b0010 : 4'b0001) : // State A
                   (state == 4'b0010) ? (in ? 4'b0010 : 4'b0100) : // State B
                   (state == 4'b0100) ? (in ? 4'b1000 : 4'b0001) : // State C
                   (state == 4'b1000) ? (in ? 4'b0010 : 4'b0100);  // State D

// Output logic
assign out = (state == 4'b1000);  // Output 1 if current state is D

endmodule