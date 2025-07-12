module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Calculate signed difference (using 2's complement)
wire signed [3:0] diff = {1'b0, A} - {1'b0, B};

// Thermometer encoding of difference
wire [3:0] therm_code;
assign therm_code[0] = (diff == 0);          // Equal
assign therm_code[1] = (diff > 0 && diff < 4);  // Small positive
assign therm_code[2] = (diff >= 4);          // Large positive
assign therm_code[3] = (diff[3]);            // Negative (MSB set)

// Decode thermometer code to outputs
assign A_equal = therm_code[0];
assign A_greater = therm_code[1] | therm_code[2];
assign A_less = therm_code[3];

endmodule