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

    // Concatenate inputs into 30-bit vector: {a,b,c,d,e,f}
    wire [29:0] all_inputs = {a, b, c, d, e, f};

    // Append two '1' bits as least significant bits to make 32 bits
    wire [31:0] combined = {all_inputs, 2'b11};

    // Split combined 32-bit vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule