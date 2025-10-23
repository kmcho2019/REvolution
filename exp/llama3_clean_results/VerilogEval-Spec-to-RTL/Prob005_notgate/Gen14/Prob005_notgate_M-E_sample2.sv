module TopModule(
    input  in,
    output out
);
    // Define a lookup table (LUT) for the NOT gate functionality
    // Since it's a NOT gate, the LUT will have 2 rows (2^1) for the input bit
    reg [1:0] lut_out;
    initial begin
        // Initialize the LUT with the NOT gate truth table
        lut_out[0] = 1'b1; // Output is 1 when input is 0
        lut_out[1] = 1'b0; // Output is 0 when input is 1
    end

    // Use the input to index into the LUT and assign the output
    always @(*) begin
        out = lut_out[in];
    end
endmodule