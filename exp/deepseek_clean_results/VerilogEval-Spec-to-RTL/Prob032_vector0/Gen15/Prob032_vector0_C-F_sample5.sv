module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Vector output mirror
    assign outv = vec;
    
    // Individual bit outputs (explicit position mapping)
    assign o2 = vec[2];  // MSB
    assign o1 = vec[1];  // Middle bit
    assign o0 = vec[0];  // LSB

endmodule