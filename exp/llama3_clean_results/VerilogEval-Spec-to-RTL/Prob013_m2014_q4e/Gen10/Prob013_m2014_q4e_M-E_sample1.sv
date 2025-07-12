module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a 2-to-1 multiplexer to implement NOR gate
// Selection lines are in1 and in2
// Data inputs are 1 (for when both in1 and in2 are 0) and 0 (for all other cases)
assign out = (in1 == 0 && in2 == 0)? 1'b1 : 1'b0;

// Alternatively, using a 2-to-1 multiplexer explicitly
// wire out_tmp;
// assign out_tmp = (in1 & in2)? 1'b0 : ((in1 | in2)? 1'b0 : 1'b1);
// assign out = out_tmp;

endmodule