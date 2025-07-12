module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly connect outv to vec for minimal logic and routing overhead
    assign outv = vec;

    // Direct continuous assignments for each bit output, simplifying structure
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule