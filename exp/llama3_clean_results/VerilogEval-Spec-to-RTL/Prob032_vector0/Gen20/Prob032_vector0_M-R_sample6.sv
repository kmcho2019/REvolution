// Refactored version of TopModule, using a slightly different structure
module TopModule(
    // 3-bit input vector
    input  [2:0] vec,
    // 3-bit output vector
    output [2:0] outv,
    // Individual bit outputs
    output       o2,
    output       o1,
    output       o0
    );

    // Directly assign the input vector to the output vector
    assign outv = vec;

    // Use always block to assign individual bits (though not necessary here, it's for demonstration)
    always @(*) begin
        o2 = vec[2]; // MSB
        o1 = vec[1];
        o0 = vec[0]; // LSB
    end

endmodule