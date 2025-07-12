module TopModule(
    input  [254:0] in,
    output [7:0]   out
);

    // Function to compute the population count recursively
    // Returns integer count of '1's in input vector 'val' with width 'width'
    function automatic integer popcount_func;
        input integer width;
        input reg [254:0] val; // large enough input to hold any width <= 255
        integer half;
        integer left_count, right_count;
        begin
            if (width == 0) begin
                popcount_func = 0;
            end else if (width == 1) begin
                popcount_func = val[0];
            end else begin
                half = width / 2;
                left_count  = popcount_func(half, val[half-1:0]);
                right_count = popcount_func(width - half, val[width-1:half]);
                popcount_func = left_count + right_count;
            end
        end
    endfunction

    // Compute 5 partial counts for 51-bit segments using the popcount_func
    wire [5:0] partial_counts [4:0]; // 6 bits for max 51 ones

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : pc51_blocks
            // Use assign with popcount_func applied on each 51-bit slice
            // cast slice to 255-bit input for function (upper bits zero)
            wire [50:0] slice = in[i*51 +: 51];
            assign partial_counts[i] = popcount_func(51, {{204{1'b0}}, slice});
        end
    endgenerate

    // Sum partial counts in a balanced adder tree
    // partial_counts are 6 bits wide, sums up to 255 max need 8 bits
    wire [7:0] sum01  = partial_counts[0] + partial_counts[1];
    wire [7:0] sum23  = partial_counts[2] + partial_counts[3];
    wire [7:0] sum0123 = sum01 + sum23;
    wire [7:0] sum_final = sum0123 + partial_counts[4];

    assign out = sum_final;

endmodule