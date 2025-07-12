module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'd0;

// Define the lookup table (LUT) for right-shifted values
reg [7:0] lut [0:255];

// Initialize the LUT with precomputed right-shifted values
initial begin
    for (int i = 0; i < 256; i++) begin
        lut[i] = (i >> 1) | (d? 8'h80 : 8'h00);
    end
end

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    q <= lut[q];  // Update q with the retrieved right-shifted value from the LUT
end

endmodule