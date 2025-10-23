module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Vector output using concatenation
    assign outv = {vec[2], vec[1], vec[0]};

    // Alternative bit assignment syntax
    assign {o2, o1, o0} = vec;

endmodule