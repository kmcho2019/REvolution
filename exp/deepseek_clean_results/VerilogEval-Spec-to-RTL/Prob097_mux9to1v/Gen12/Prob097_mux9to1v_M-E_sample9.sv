module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

// Concatenate all inputs into a single vector
wire [143:0] input_concat = {i, h, g, f, e, d, c, b, a};

// Generate each output bit independently
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin : bit_slice
        // Calculate the starting bit for this position in concatenated vector
        localparam START_BIT = bit_idx * 9;
        
        // Extract the 9 relevant bits for this position
        wire [8:0] bit_slice = input_concat[START_BIT +: 9];
        
        // Select the appropriate bit based on sel
        assign out[bit_idx] = (sel < 9) ? bit_slice[sel] : 1'b1;
    end
endgenerate

endmodule