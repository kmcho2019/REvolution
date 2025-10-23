module TopModule (
    input  [3:0] x, // Note: Although problem statement says x is 4 bits, 
                     // the K-map suggests x[3]x[0] which corresponds to x[3] and x[0] in Verilog 4-bit vector
    output reg f
);

always @(*) begin
    // Based on the observed patterns in the K-map
    f = (x[3] && x[0] && (x[1] || x[2])) || 
        (x[3] && !x[0] && x[1] && x[2]) || 
        (!x[3] && x[0] && x[1] && x[2]);
end

endmodule