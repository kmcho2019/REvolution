module TopModule(
    input  d,
    input  ena,
    output reg q
);
// The assign statement directly implements the D latch behavior, 
// assigning 'd' to 'q' when 'ena' is high and retaining 'q' when 'ena' is low.
assign q = (ena)? d : q;

endmodule