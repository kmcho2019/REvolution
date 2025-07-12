module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a 5-bit vector: inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to get output bit index from (i, j)
    function automatic int get_index(input int i, input int j);
        get_index = 24 - (i*5 + j);
    endfunction

    // Function to compute out bits
    function automatic bit cmp_bit(input int i, input int j, input [4:0] in_vec, input [24:0] partial_out);
        if (i <= j) begin
            // XNOR inputs for upper triangle and diagonal
            cmp_bit = ~(in_vec[4 - i] ^ in_vec[4 - j]);
        end else begin
            // Reuse symmetric bit from partial_out for lower triangle
            cmp_bit = partial_out[get_index(j, i)];
        end
    endfunction

    // Generate all output bits by unrolled assign statements
    // We must handle recursion for lower triangle reuse, so we build incrementally

    // Because partial_out depends on itself for lower triangle,
    // we separate computation in two steps: compute upper triangle first,
    // then assign lower triangle bits by referencing upper triangle bits.

    // Step 1: create a wire array for upper triangle bits
    wire [14:0] upper_bits; // There are 15 unique pairs with i ≤ j

    // Map for upper bits index: index in upper_bits corresponds to pair (i,j) where i ≤ j
    // We'll define a function to compute this index
    function automatic int upper_idx(input int i, input int j);
        int count, x, y;
        count = 0;
        for (x = 0; x < 5; x = x + 1) begin
            for (y = x; y < 5; y = y + 1) begin
                if (x == i && y == j) begin
                    upper_idx = count;
                    return;
                end
                count = count + 1;
            end
        end
        upper_idx = -1; // shouldn't happen
    endfunction

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i_upper
            for (j = i; j < 5; j = j + 1) begin : gen_j_upper
                localparam int idx = upper_idx(i,j);
                assign upper_bits[idx] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    endgenerate

    // Step 2: assign all out bits by using upper_bits for i ≤ j and symmetric mapping for i > j
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i_out
            for (j = 0; j < 5; j = j + 1) begin : gen_j_out
                localparam int oidx = 24 - (i*5 + j);
                if (i <= j) begin
                    localparam int uidx = upper_idx(i,j);
                    assign out[oidx] = upper_bits[uidx];
                end else begin
                    localparam int uidx = upper_idx(j,i);
                    assign out[oidx] = upper_bits[uidx];
                end
            end
        end
    endgenerate

endmodule