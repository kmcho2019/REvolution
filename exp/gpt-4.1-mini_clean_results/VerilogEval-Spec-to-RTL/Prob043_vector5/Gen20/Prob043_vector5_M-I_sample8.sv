module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into array for index-based access
    wire [4:0] inputs = {a,b,c,d,e};

    // Number of inputs
    localparam N = 5;

    // Declare an array to hold upper triangle comparisons (including diagonal)
    // There are N*(N+1)/2 = 15 unique pairs with i <= j
    // Store in a 1D array: index = i*(N) - i*(i-1)/2 + (j - i)
    // For example, (0,0) => 0; (0,1) =>1; (1,1)=>N etc.
    reg [14:0] upper_eq;

    integer i,j, idx;

    // Compute only upper triangle comparisons
    always @(*) begin
        idx = 0;
        for (i = 0; i < N; i = i + 1) begin
            for (j = i; j < N; j = j + 1) begin
                upper_eq[idx] = ~(inputs[i] ^ inputs[j]);
                idx = idx + 1;
            end
        end
    end

    // Function to get index into upper_eq for pair (i,j) with i<=j
    function automatic int upper_idx(input int row, input int col);
        int base;
        begin
            base = row * N - (row*(row-1)) / 2;
            upper_idx = base + (col - row);
        end
    endfunction

    // Build the output vector, iterating over all pairs i,j
    // out[24 - (5*i + j)] = eq of inputs[i] and inputs[j]
    // If i <= j, use upper_eq directly
    // Else i > j, use symmetry: eq(i,j) = eq(j,i)
    reg [24:0] out_reg;
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                int bit_index;
                bit_index = 24 - (5*i + j);
                if (i <= j)
                    out_reg[bit_index] = upper_eq[upper_idx(i,j)];
                else
                    out_reg[bit_index] = upper_eq[upper_idx(j,i)];
            end
        end
    end

    assign out = out_reg;

endmodule