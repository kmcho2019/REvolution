module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Combined assignments using bit extraction and concatenation
    assign {o2, o1, o0} = vec;
    assign outv = {vec[2], vec[1], vec[0]};  // Alternative way to express same connection

endmodule