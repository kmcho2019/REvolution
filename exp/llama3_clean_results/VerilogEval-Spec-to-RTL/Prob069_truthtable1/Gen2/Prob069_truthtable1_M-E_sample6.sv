module TopModule(
    input  logic x3,
    input  logic x2,
    input  logic x1,
    output logic f
);

    logic [7:0] lut; // 8-entry LUT
    logic [2:0] addr; // 3-bit address to select LUT entry

    // Initialize the LUT with values from the truth table
    initial begin
        lut[0] = 0; // 000
        lut[1] = 0; // 001
        lut[2] = 1; // 010
        lut[3] = 1; // 011
        lut[4] = 0; // 100
        lut[5] = 1; // 101
        lut[6] = 0; // 110
        lut[7] = 1; // 111
    end

    // Combine inputs to form the address for the LUT
    assign addr = {x3, x2, x1};

    // Use the LUT to determine the output
    assign f = lut[addr];

endmodule