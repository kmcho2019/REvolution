// Module A: z = (x XOR y) AND x
// Inputs: x, xor_xy (precomputed x ^ y)
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
// Simply outputs inv_xor_xy input
module B (
    input  wire inv_xor_xy,
    output wire z
);
    assign z = inv_xor_xy;
endmodule

// Top-level module:
// Instantiates two A and two B modules using generate loops,
// shares xor_xy and inv_xor_xy signals,
// computes outputs according to problem statement
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire inv_xor_xy;

    // Compute shared signals
    assign xor_xy = x ^ y;
    assign inv_xor_xy = ~xor_xy;

    // Declare outputs of submodules as arrays
    wire [1:0] a_out;
    wire [1:0] b_out;

    // Instantiate two A modules
    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_A
            A a_inst (
                .x(x),
                .xor_xy(xor_xy),
                .z(a_out[i])
            );
        end
    endgenerate

    // Instantiate two B modules
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_B
            B b_inst (
                .inv_xor_xy(inv_xor_xy),
                .z(b_out[i])
            );
        end
    endgenerate

    // Compute intermediate results:
    // OR of first pair (A[0], B[0])
    wire or_out = a_out[0] | b_out[0];
    // AND of second pair (A[1], B[1])
    wire and_out = a_out[1] & b_out[1];

    // Final output z is XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule