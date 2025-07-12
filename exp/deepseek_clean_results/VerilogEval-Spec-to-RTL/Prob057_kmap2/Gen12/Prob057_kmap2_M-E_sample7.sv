module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Majority function definition
function automatic maj3;
    input x, y, z;
    maj3 = (x & y) | (y & z) | (x & z);
endfunction

// Intermediate majority calculations
wire maj1 = maj3(~a, b, c);
wire maj2 = maj3(a, ~b, d);
wire maj3 = maj3(~c, d, ~a);

// Final majority output
assign out = maj3(maj1, maj2, maj3);

endmodule