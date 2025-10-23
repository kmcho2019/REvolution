module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a multiplexer to implement a NOR gate
// Select lines are in1 and in2
// Data inputs are 1 (for the case when both in1 and in2 are 0) and 0 (for all other cases)
assign out = (in1 == 1'b0 && in2 == 1'b0) ? 1'b1 : 1'b0;

// Alternative implementation using a case statement for clarity
// assign out = (in1 == 1'b0 && in2 == 1'b0) ? 1'b1 : (in1 == 1'b1 || in2 == 1'b1) ? 1'b0 : 1'bx;

endmodule