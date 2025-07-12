module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Number of partial products
    localparam WIDTH = 16;
    localparam N = 8;

    // Partial products array
    wire [WIDTH-1:0] partial_products [N-1:0];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A << i) : {WIDTH{1'b0}};
        end
    endgenerate

    // Temporary arrays to hold sums at each reduction level
    // Maximum number of reduction levels: ceil(log2(N)) = 3
    // Use a multi-dimensional array for stages: stage -> array of partial sums
    // Each subsequent stage has roughly half the size of the previous
    // Stage 0: partial_products (size N=8)
    // Stage 1: size 4
    // Stage 2: size 2
    // Stage 3: size 1 (final product)

    // We'll create registers of wires for each stage
    // Note: because Verilog does not support variable-length arrays easily,
    // we use generate loops and arrays of wires

    // Stage arrays definition
    wire [WIDTH-1:0] stage_0 [N-1:0];
    wire [WIDTH-1:0] stage_1 [3:0];
    wire [WIDTH-1:0] stage_2 [1:0];
    wire [WIDTH-1:0] stage_3;

    // Assign stage 0 from partial_products
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign stage_0[i] = partial_products[i];
        end
    endgenerate

    // Stage 1: sum pairs of stage_0
    generate
        for (i = 0; i < 4; i = i + 1) begin
            assign stage_1[i] = stage_0[2*i] + stage_0[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs of stage_1
    generate
        for (i = 0; i < 2; i = i + 1) begin
            assign stage_2[i] = stage_1[2*i] + stage_1[2*i+1];
        end
    endgenerate

    // Stage 3: final sum of stage_2
    assign stage_3 = stage_2[0] + stage_2[1];

    assign product = stage_3;

endmodule