module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the input signals as a wire array for easier manipulation
wire [4:0] signals = {a, b, c, d, e};

// Create a lookup table (LUT) to store the results of the comparisons
reg [24:0] lut [2**5-1:0];

// Initialize the LUT with the results of the comparisons
initial begin
    for (int i = 0; i < 2**5; i++) begin
        reg [4:0] currSignals;
        currSignals = i;
        for (int j = 0; j < 5; j++) begin
            for (int k = 0; k < 5; k++) begin
                if (currSignals[j] == currSignals[k])
                    lut[i][j*5 + k] = 1'b1;
                else
                    lut[i][j*5 + k] = 1'b0;
            end
        end
    end
end

// Use the LUT to generate the output
always @(*) begin
    out = lut[{a, b, c, d, e}];
end

endmodule