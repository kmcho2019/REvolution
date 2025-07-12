module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Full vector output
    assign outv = vec;
    
    // Individual bit outputs with explicit mapping
    assign o2 = vec[2];  // MSB
    assign o1 = vec[1];  // Middle bit
    assign o0 = vec[0];  // LSB

endmodule