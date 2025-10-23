module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);
    // Define local parameters for widths
    localparam IN_WIDTH  = 5;
    localparam NUM_INPUTS = 6;
    localparam TOTAL_IN_WIDTH = IN_WIDTH * NUM_INPUTS; // 30
    localparam TOTAL_OUT_WIDTH = 32;

    // Concatenate all inputs into a 30-bit vector
    wire [TOTAL_IN_WIDTH-1:0] concatenated_inputs = {a, b, c, d, e, f};

    // Append two '1' bits to form a 32-bit vector
    wire [TOTAL_OUT_WIDTH-1:0] combined = {concatenated_inputs, 2'b11};

    // Slice combined into 4 outputs of 8 bits each
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule