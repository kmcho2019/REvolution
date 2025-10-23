module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    assign {outv, o2, o1, o0} = {vec, vec[2:0]};

endmodule