module TopModule(output out);
    // Implement a 1-bit LUT that always outputs 0
    // The LUT has no inputs and simply hardcodes the output
    LUT #(.INIT(1'b0)) zero_lut (.O(out));
endmodule