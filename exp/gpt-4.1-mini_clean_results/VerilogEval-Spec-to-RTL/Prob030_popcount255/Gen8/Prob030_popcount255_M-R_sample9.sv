module popcount5 (
    input  [4:0] in,
    output [2:0] out
);
    // Direct sum of bits as integers
    assign out = in[0] + in[1] + in[2] + in[3] + in[4];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Step 1: Divide input into 51 groups of 5 bits and get partial popcounts
    wire [2:0] partial_counts [0:50];

    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : gen_popcount5
            popcount5 pc5 (
                .in(in[i*5 +: 5]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Recursive function for hierarchical summation
    // Takes an array of elements and size, returns sum (up to 8 bits)
    function [7:0] sum_popcounts;
        input integer size;
        input [2:0] counts_array [0:50]; // max 51 elements
        integer idx;
        reg [7:0] temp_sums [0:50];
        integer new_size;
        begin
            if (size == 1) begin
                sum_popcounts = counts_array[0];
            end else begin
                new_size = 0;
                // Sum pairs and store in temp_sums
                for (idx = 0; idx < size / 2; idx = idx + 1) begin
                    temp_sums[idx] = counts_array[2*idx] + counts_array[2*idx+1];
                end
                if (size % 2 == 1) begin
                    temp_sums[size/2] = counts_array[size-1];
                    new_size = (size / 2) + 1;
                end else begin
                    new_size = size / 2;
                end
                // Recurse with smaller set
                // Cast temp_sums back to 3-bit array truncated accordingly for recursion
                // Use an intermediate array of 3-bit elements truncated from temp_sums
                reg [2:0] next_level [0:50];
                for (idx = 0; idx < new_size; idx = idx + 1) begin
                    // Truncate to 3 bits for next recursion; sum cannot exceed 255 here, so safe
                    // But for next recursion, it should be widened; so we will reinterpret the array width for next calls
                    // Since sum_popcounts input is 3-bit wide, but actual sums can be wider,
                    // we re-implement sum_popcounts with input width parameter to handle this.
                    // To keep simplicity, call a separate helper function below.
                end
                // Instead of complicated cast, delegate to helper function with wider inputs.
                sum_popcounts = sum_popcounts_wide(temp_sums, new_size);
            end
        end
    endfunction

    // Helper function handling wider inputs up to 8 bits
    function [7:0] sum_popcounts_wide;
        input [7:0] vals [0:50];
        input integer sz;
        integer j;
        reg [7:0] tmp [0:50];
        integer nsz;
        begin
            if (sz == 1) begin
                sum_popcounts_wide = vals[0];
            end else begin
                nsz = 0;
                for (j = 0; j < sz/2; j = j + 1) begin
                    tmp[j] = vals[2*j] + vals[2*j+1];
                end
                if (sz % 2 == 1) begin
                    tmp[sz/2] = vals[sz-1];
                    nsz = (sz / 2) + 1;
                end else begin
                    nsz = sz / 2;
                end
                sum_popcounts_wide = sum_popcounts_wide(tmp, nsz);
            end
        end
    endfunction

    // Convert partial_counts (3 bits each) to 8-bit for starting recursive summation
    wire [7:0] partial_counts_8 [0:50];
    generate
        for (i = 0; i < 51; i = i + 1) begin : extend_width
            assign partial_counts_8[i] = {5'b0, partial_counts[i]};
        end
    endgenerate

    // Call recursive summation on partial_counts_8 array
    // Can't call function in assign with unpacked array directly,
    // so workaround with a for-generate block to reduce step by step.

    // Instead, implement iterative reduction using a generate block:

    // We'll do a loop generating layers of sums till one element remains.

    // Maximum number of elements at each level will be 51 initially, halving each time.

    localparam MAX_LAYERS = 6;
    // Declare sum arrays per layer (layer 0 is partial_counts_8)
    wire [7:0] sums [0:MAX_LAYERS][0:50];

    // Assign layer 0 (initial partial counts)
    generate
        for (i = 0; i < 51; i = i + 1) begin : assign_layer0
            assign sums[0][i] = partial_counts_8[i];
        end
    endgenerate

    // For each subsequent layer, sum pairs of previous layer
    genvar layer, idx;
    generate
        for (layer = 1; layer <= MAX_LAYERS; layer = layer + 1) begin : sum_layers
            localparam integer prev_size = (layer == 1) ? 51 : ( ( ( (layer-1) == 1) ? ((51 + 1) / 2) : 0) ); 
            // We must compute sizes per layer dynamically. To simplify, precompute sizes here.

            // Instead, precompute sizes in a function:
            function integer size_at_layer;
                input integer l;
                integer s;
                begin
                    s = 51;
                    for (integer ll = 1; ll <= l; ll = ll +1) begin
                        s = (s + 1) / 2;
                    end
                    size_at_layer = s;
                end
            endfunction

            localparam integer prev_sz = size_at_layer(layer-1);
            localparam integer curr_sz = size_at_layer(layer);

            for (idx = 0; idx < curr_sz; idx = idx + 1) begin : sum_pairs
                if (2*idx+1 < prev_sz) begin
                    assign sums[layer][idx] = sums[layer-1][2*idx] + sums[layer-1][2*idx+1];
                end else begin
                    assign sums[layer][idx] = sums[layer-1][2*idx];
                end
            end
        end
    endgenerate

    // The final sum is at layer MAX_LAYERS, index 0
    // Let's find the size at MAX_LAYERS:
    function integer size_at_layer_f;
        input integer l;
        integer s;
        begin
            s = 51;
            for (integer ll = 1; ll <= l; ll = ll +1) begin
                s = (s + 1) / 2;
            end
            size_at_layer_f = s;
        end
    endfunction

    // Check final size is 1 to ensure final sum at sums[MAX_LAYERS][0]
    localparam integer final_size = size_at_layer_f(MAX_LAYERS);
    // For 51, after 6 halvings: 51->26->13->7->4->2->1

    assign out = sums[MAX_LAYERS][0];

endmodule