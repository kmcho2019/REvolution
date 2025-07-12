module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Vector output assignment
    assign outv[2] = vec[2];
    assign outv[1] = vec[1];
    assign outv[0] = vec[0];
    
    // Individual bit outputs
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule