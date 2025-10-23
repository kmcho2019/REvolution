module TopModule(
    input  [254:0] in,
    output [7:0]   out
);

    // Recursive function to calculate population count of a vector slice
    // Returns integer count of '1's in in_vector[from:to]
    function integer popcount;
        input [254:0] in_vector;
        input integer from_idx;
        input integer to_idx;
        integer mid;
        begin
            if (from_idx == to_idx) begin
                popcount = in_vector[from_idx];
            end else begin
                mid = (from_idx + to_idx) >> 1;
                popcount = popcount(in_vector, from_idx, mid) + popcount(in_vector, mid+1, to_idx);
            end
        end
    endfunction

    // Calculate population count of entire input
    wire [8:0] total_count; // 9 bits to accommodate 0..255
    assign total_count = popcount(in, 0, 254);

    // Assign lower 8 bits as output
    assign out = total_count[7:0];

endmodule