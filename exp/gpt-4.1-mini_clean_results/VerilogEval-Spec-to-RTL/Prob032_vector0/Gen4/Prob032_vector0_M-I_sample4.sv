module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Direct assignments to minimize logic and routing overhead
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

    assign outv = vec;

endmodule