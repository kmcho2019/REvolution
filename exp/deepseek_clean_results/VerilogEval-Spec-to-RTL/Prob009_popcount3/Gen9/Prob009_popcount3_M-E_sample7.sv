module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Thermometer-coded intermediate representation
    wire [3:0] therm;
    assign therm[0] = 1'b1;  // Always on (base case)
    assign therm[1] = (in[0]) ? 1'b1 : therm[0];
    assign therm[2] = (in[1]) ? 1'b1 : therm[1];
    assign therm[3] = (in[2]) ? 1'b1 : therm[2];

    // Convert thermometer code to binary output
    assign out[0] = therm[1] ^ therm[3];  // XOR of odd positions
    assign out[1] = therm[2] | therm[3];  // OR of upper bits

endmodule