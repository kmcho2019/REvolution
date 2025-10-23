module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    
    // Continuous assignment for the vector output
    assign outv = vec;
    
    // Procedural assignment for individual bits
    always_comb begin
        o2 = vec[2];  // MSB
        o1 = vec[1];  // Middle bit
        o0 = vec[0];  // LSB
    end

endmodule