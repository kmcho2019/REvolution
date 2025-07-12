module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

// Define the LUT
reg [7:0] lut [256];

// Initialize the LUT
initial begin
    for (int i = 0; i < 256; i++) begin
        lut[i] = {i[0], i[7:1]};
    end
end

always @(posedge clk) begin
    q_reg <= lut[{d, q_reg[7:1]}];
end

assign q = q_reg;

endmodule