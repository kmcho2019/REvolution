module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Compute bitwise-OR directly within the TopModule
    assign out_or_bitwise = a | b;

    // Perform logical OR by checking if any bit of either vector is set
    assign out_or_logical = (a != 3'b000) || (b != 3'b000);

    // Invert vectors a and b and concatenate the results
    assign out_not = {~b, ~a};
endmodule