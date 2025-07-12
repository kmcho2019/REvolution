module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// Define the 4-bit LUT
reg [3:0] lut [15:0];

// Initialize the LUT with a specific feedback function
initial begin
    lut[0] = 4'b0001;
    lut[1] = 4'b0010;
    lut[2] = 4'b0011;
    lut[3] = 4'b0100;
    lut[4] = 4'b0101;
    lut[5] = 4'b0110;
    lut[6] = 4'b0111;
    lut[7] = 4'b1000;
    lut[8] = 4'b1001;
    lut[9] = 4'b1010;
    lut[10] = 4'b1011;
    lut[11] = 4'b1100;
    lut[12] = 4'b1101;
    lut[13] = 4'b1110;
    lut[14] = 4'b1111;
    lut[15] = 4'b0000;
end

// LFSR logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Use the LUT to generate the next state
        out <= lut[out];
    end
end

endmodule