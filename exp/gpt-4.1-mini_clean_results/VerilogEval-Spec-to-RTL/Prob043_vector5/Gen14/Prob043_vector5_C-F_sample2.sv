module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into vector: inputs[4]=a, ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};
    
    // We'll use an internal wire array to store computed upper-triangular XNOR results
    wire [14:0] upper_tri_bits; 
    // Mapping: number of elements in upper triangle including diagonal: 5+4+3+2+1=15

    // Function to map (i,j) with i<=j to index in upper_tri_bits
    function integer upper_tri_index;
        input integer row; // i
        input integer col; // j, with col >= row
        integer offset;
        begin
            // Number of elements in previous rows:
            // row=0: offset=0
            // row=1: offset=5
            // row=2: offset=5+4=9
            // row=3: offset=5+4+3=12
            // row=4: offset=5+4+3+2=14
            // Formula: offset = sum_{k=0}^{row-1} (5 - k) = 5*row - (row*(row-1))/2
            offset = 5*row - (row*(row-1))/2;
            upper_tri_index = offset + (col - row);
        end
    endfunction

    genvar idx;
    generate
        // Compute only upper triangle and diagonal bits (i <= j)
        for (idx = 0; idx < 15; idx = idx +1) begin : gen_upper_tri
            // Reverse mapping idx back to (i,j)
            // We'll iterate to find i,j for given idx:
            // Because idx is monotonic with (i,j) in upper triangle, 
            // we can build combinational logic as below.

            // Implement a combinational function to find (i,j)
            // But Verilog generate does not support runtime, so use a workaround.
            // Instead, we unroll i and j loops inside the generate to assign bits.

            // To do this cleanly, use nested generate loops over i,j with i<=j and assign upper_tri_bits accordingly.
        end
    endgenerate

    // Nested generate loops to assign upper_tri_bits:
    genvar i, j, ut_idx;
    generate
        ut_idx = 0;
        for (i = 0; i < 5; i = i + 1) begin: gen_i
            for (j = i; j < 5; j = j + 1) begin: gen_j
                assign upper_tri_bits[ut_idx] = inputs[4 - i] ~^ inputs[4 - j];
                ut_idx = ut_idx + 1;
            end
        end
    endgenerate

    // Now assign all 25 output bits using symmetry:
    // out[24 - (5*i + j)] corresponds to inputs[4 - i] and inputs[4 - j]
    // If i <= j, use upper_tri_bits index
    // Else (i > j), use upper_tri_bits index for (j,i) (symmetry)
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : gen_out_bits
            integer row = idx / 5;
            integer col = idx % 5;
            integer out_idx = 24 - idx;
            if (row <= col) begin
                // i <= j, direct mapping
                assign out[out_idx] = upper_tri_bits[upper_tri_index(row, col)];
            end else begin
                // i > j, mirror from (j, i)
                assign out[out_idx] = upper_tri_bits[upper_tri_index(col, row)];
            end
        end
    endgenerate

endmodule