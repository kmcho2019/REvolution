// TopModule: A combinational circuit implementing the output based on a Majority Voter and inverter
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Calculate the output using a Majority Voter and inverter
    logic maj_ab, maj_ac, maj_ad, maj_bc, maj_bd, maj_cd;
    assign maj_ab = a & b;
    assign maj_ac = a & c;
    assign maj_ad = a & d;
    assign maj_bc = b & c;
    assign maj_bd = b & d;
    assign maj_cd = c & d;

    logic maj_abcd;
    assign maj_abcd = (maj_ab & maj_cd) | (maj_ac & maj_bd) | (maj_ad & maj_bc);

    assign q = ~(maj_abcd | (a & b & c & d));

endmodule