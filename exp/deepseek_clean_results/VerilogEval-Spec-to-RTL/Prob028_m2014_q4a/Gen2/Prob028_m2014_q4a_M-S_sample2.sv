module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) 
    if (ena)
        q = d;
    // else q retains its value (implicit latch behavior)

endmodule