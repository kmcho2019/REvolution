module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Number of inputs
    localparam N = 100;

    // Calculate next power of two >= N for padding
    function integer clog2(input integer value);
        integer i;
        begin
            clog2 = 0;
            for (i = value-1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam LOG2N = clog2(N);
    localparam SIZE = 1 << LOG2N; // next power of two

    // Pad input with ones for AND and zeros for OR, XOR with 0 to not affect parity
    wire [SIZE-1:0] and_stage_0;
    wire [SIZE-1:0] or_stage_0;
    wire [SIZE-1:0] xor_stage_0;

    genvar i;

    generate
        for (i = 0; i < SIZE; i = i + 1) begin : stage0_init
            assign and_stage_0[i] = (i < N) ? in[i] : 1'b1;  // pad AND with 1 so it doesn't affect AND
            assign or_stage_0[i]  = (i < N) ? in[i] : 1'b0;  // pad OR with 0 so it doesn't affect OR
            assign xor_stage_0[i] = (i < N) ? in[i] : 1'b0;  // pad XOR with 0 so it doesn't affect parity
        end
    endgenerate

    // Recursive tree reduction function for AND, OR, XOR
    // Implemented iteratively by stages

    // Stage widths halve each time
    // We create arrays of wires for each stage

    // Maximum stages needed: LOG2N
    // Define arrays of wires for intermediate stages

    // Arrays of wires for each stage; stage s has SIZE/(2^s) elements
    // Using two-dimensional arrays is not supported for ports, but we can declare arrays of wires inside generate blocks

    // Declare arrays of wires for each stage:
    // We'll store stage signals in localparams arrays using generate loops

    // We'll do stages iteratively:

    // And
    wire [SIZE/2-1:0] and_stage_1;
    wire [SIZE/4-1:0] and_stage_2;
    wire [SIZE/8-1:0] and_stage_3;
    wire [SIZE/16-1:0] and_stage_4;
    wire [SIZE/32-1:0] and_stage_5;
    wire [SIZE/64-1:0] and_stage_6;
    wire [SIZE/128-1:0] and_stage_7;

    // Or
    wire [SIZE/2-1:0] or_stage_1;
    wire [SIZE/4-1:0] or_stage_2;
    wire [SIZE/8-1:0] or_stage_3;
    wire [SIZE/16-1:0] or_stage_4;
    wire [SIZE/32-1:0] or_stage_5;
    wire [SIZE/64-1:0] or_stage_6;
    wire [SIZE/128-1:0] or_stage_7;

    // Xor
    wire [SIZE/2-1:0] xor_stage_1;
    wire [SIZE/4-1:0] xor_stage_2;
    wire [SIZE/8-1:0] xor_stage_3;
    wire [SIZE/16-1:0] xor_stage_4;
    wire [SIZE/32-1:0] xor_stage_5;
    wire [SIZE/64-1:0] xor_stage_6;
    wire [SIZE/128-1:0] xor_stage_7;

    // Stage 1: combine pairs from stage 0
    generate
        for (i = 0; i < SIZE/2; i = i + 1) begin : stage1
            assign and_stage_1[i] = and_stage_0[2*i] & and_stage_0[2*i+1];
            assign or_stage_1[i]  = or_stage_0[2*i]  | or_stage_0[2*i+1];
            assign xor_stage_1[i] = xor_stage_0[2*i] ^ xor_stage_0[2*i+1];
        end
    endgenerate

    // Stage 2
    generate
        for (i = 0; i < SIZE/4; i = i + 1) begin : stage2
            assign and_stage_2[i] = and_stage_1[2*i] & and_stage_1[2*i+1];
            assign or_stage_2[i]  = or_stage_1[2*i]  | or_stage_1[2*i+1];
            assign xor_stage_2[i] = xor_stage_1[2*i] ^ xor_stage_1[2*i+1];
        end
    endgenerate

    // Stage 3
    generate
        for (i = 0; i < SIZE/8; i = i + 1) begin : stage3
            assign and_stage_3[i] = and_stage_2[2*i] & and_stage_2[2*i+1];
            assign or_stage_3[i]  = or_stage_2[2*i]  | or_stage_2[2*i+1];
            assign xor_stage_3[i] = xor_stage_2[2*i] ^ xor_stage_2[2*i+1];
        end
    endgenerate

    // Stage 4
    generate
        for (i = 0; i < SIZE/16; i = i + 1) begin : stage4
            assign and_stage_4[i] = and_stage_3[2*i] & and_stage_3[2*i+1];
            assign or_stage_4[i]  = or_stage_3[2*i]  | or_stage_3[2*i+1];
            assign xor_stage_4[i] = xor_stage_3[2*i] ^ xor_stage_3[2*i+1];
        end
    endgenerate

    // Stage 5
    generate
        for (i = 0; i < SIZE/32; i = i + 1) begin : stage5
            assign and_stage_5[i] = and_stage_4[2*i] & and_stage_4[2*i+1];
            assign or_stage_5[i]  = or_stage_4[2*i]  | or_stage_4[2*i+1];
            assign xor_stage_5[i] = xor_stage_4[2*i] ^ xor_stage_4[2*i+1];
        end
    endgenerate

    // Stage 6
    generate
        for (i = 0; i < SIZE/64; i = i + 1) begin : stage6
            assign and_stage_6[i] = and_stage_5[2*i] & and_stage_5[2*i+1];
            assign or_stage_6[i]  = or_stage_5[2*i]  | or_stage_5[2*i+1];
            assign xor_stage_6[i] = xor_stage_5[2*i] ^ xor_stage_5[2*i+1];
        end
    endgenerate

    // Stage 7 (only needed if SIZE=128)
    generate if (SIZE == 128) begin : stage7
        assign and_stage_7[0] = and_stage_6[0] & and_stage_6[1];
        assign or_stage_7[0]  = or_stage_6[0]  | or_stage_6[1];
        assign xor_stage_7[0] = xor_stage_6[0] ^ xor_stage_6[1];
    end endgenerate

    // Final outputs:
    // If SIZE=128, final output from stage7[0]
    // Else if SIZE=64, final output from stage6[0], etc.

    generate
        if (SIZE == 128) begin
            assign out_and = and_stage_7[0];
            assign out_or  = or_stage_7[0];
            assign out_xor = xor_stage_7[0];
        end else if (SIZE == 64) begin
            assign out_and = and_stage_6[0];
            assign out_or  = or_stage_6[0];
            assign out_xor = xor_stage_6[0];
        end else if (SIZE == 32) begin
            assign out_and = and_stage_5[0];
            assign out_or  = or_stage_5[0];
            assign out_xor = xor_stage_5[0];
        end else if (SIZE == 16) begin
            assign out_and = and_stage_4[0];
            assign out_or  = or_stage_4[0];
            assign out_xor = xor_stage_4[0];
        end else if (SIZE == 8) begin
            assign out_and = and_stage_3[0];
            assign out_or  = or_stage_3[0];
            assign out_xor = xor_stage_3[0];
        end else if (SIZE == 4) begin
            assign out_and = and_stage_2[0];
            assign out_or  = or_stage_2[0];
            assign out_xor = xor_stage_2[0];
        end else if (SIZE == 2) begin
            assign out_and = and_stage_1[0];
            assign out_or  = or_stage_1[0];
            assign out_xor = xor_stage_1[0];
        end else begin
            // if SIZE=1 (N=1)
            assign out_and = and_stage_0[0];
            assign out_or  = or_stage_0[0];
            assign out_xor = xor_stage_0[0];
        end
    endgenerate

endmodule