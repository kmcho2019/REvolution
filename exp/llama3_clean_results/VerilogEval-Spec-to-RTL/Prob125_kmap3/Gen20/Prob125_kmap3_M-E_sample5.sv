module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

// Define the lookup table
reg [1:0] lut_addr;
reg [0:0] lut_out [7:0];

// Initialize the lookup table
initial begin
    lut_out[0] = 1'b0; // a=0, b=0, c=0
    lut_out[1] = 1'b0; // a=0, b=0, c=1
    lut_out[2] = 1'b1; // a=0, b=1, c=0
    lut_out[3] = 1'b1; // a=0, b=1, c=1
    lut_out[4] = 1'b1; // a=1, b=0, c=0
    lut_out[5] = 1'b1; // a=1, b=0, c=1
    lut_out[6] = 1'b1; // a=1, b=1, c=0
    lut_out[7] = 1'b1; // a=1, b=1, c=1
end

// Use the inputs to address the lookup table
always @(*) begin
    lut_addr = {a, b, c};
    out = lut_out[lut_addr];
end

endmodule