// Define the LUTs as arrays
reg [63:0] lut_p1y;
reg [15:0] lut_p2y;

// Initialize the LUTs with the pre-computed output values
initial begin
    // Initialize p1y LUT
    for (int i = 0; i < 64; i++) begin
        reg [5:0] inputs;
        inputs = i;
        reg and1, and2;
        and1 = inputs[5] & inputs[4] & inputs[3];
        and2 = inputs[2] & inputs[1] & inputs[0];
        lut_p1y[i] = and1 | and2;
    end

    // Initialize p2y LUT
    for (int i = 0; i < 16; i++) begin
        reg [3:0] inputs;
        inputs = i;
        reg and3, and4;
        and3 = inputs[3] & inputs[2];
        and4 = inputs[1] & inputs[0];
        lut_p2y[i] = and3 | and4;
    end
end

// Define the TopModule
module TopModule(
    input [5:0] p1,
    input [3:0] p2,
    output p1y,
    output p2y
);

    // Use the LUTs to generate the output values
    assign p1y = lut_p1y[p1];
    assign p2y = lut_p2y[p2];

endmodule