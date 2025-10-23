module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Internal wires for intermediate sums
    wire [15:0] sum [7:0];

    // Generate conditional shifted addends for each bit of B and accumulate results
    // sum[-1] assumed zero for the first addition
    // sum[i] = sum[i-1] + (B[i] ? (A << i) : 0)
    // To handle sum[-1], we define sum[-1] as 0 in generate loop by starting at i=0 carefully

    // Partial shifted values based on B bits
    wire [15:0] shifted_A [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift_and_add
            assign shifted_A[i] = B[i] ? (16'd0 + (A << i)) : 16'd0;
        end
    endgenerate

    // Accumulate sums sequentially in combinational logic
    // Using a chain of additions: sum[0] = shifted_A[0], sum[1] = sum[0] + shifted_A[1], ...
    // sum[i] = sum[i-1] + shifted_A[i];
    // For i=0, sum[-1] is zero.
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_accum
            if (i == 0) begin
                assign sum[i] = shifted_A[0];
            end else begin
                assign sum[i] = sum[i-1] + shifted_A[i];
            end
        end
    endgenerate

    assign product = sum[7];

endmodule