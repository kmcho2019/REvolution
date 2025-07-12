module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the LUT as a 2D array
reg [24:0] lut[32];

// Initialize the LUT
initial begin
    for (int i = 0; i < 32; i++) begin
        reg [4:0] signals = i;
        for (int j = 0; j < 5; j++) begin
            for (int k = 0; k < 5; k++) begin
                lut[i][j*5 + k] = (signals[j] == signals[k]);
            end
        end
    end
end

// Use the LUT to implement the TopModule
always @(*) begin
    reg [4:0] index = {a, b, c, d, e};
    out = lut[index];
end

endmodule