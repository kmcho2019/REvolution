module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

    // Pack inputs into array for indexed access
    wire [15:0] inputs_arr [0:8];
    assign inputs_arr[0] = a;
    assign inputs_arr[1] = b;
    assign inputs_arr[2] = c;
    assign inputs_arr[3] = d;
    assign inputs_arr[4] = e;
    assign inputs_arr[5] = f;
    assign inputs_arr[6] = g;
    assign inputs_arr[7] = h;
    assign inputs_arr[8] = i;

    // Intermediate signals for hierarchical muxing (up to 4 levels)
    // Level count: ceil(log2(9)) = 4 levels (max)
    // Each level halves the number of mux inputs
    // Use generate to build balanced mux tree

    // Calculate max mux inputs per level and depth
    localparam MAX_LEVELS = 4;

    // Declare reg array to hold mux outputs per level
    // Level 0 is inputs_arr (9 elements)
    reg [15:0] level [0:MAX_LEVELS][0:15]; // max 16 elements for safe sizing

    integer i, idx;

    always @* begin
        // Initialize level 0 with inputs_arr plus one extra element for padding
        // Padding element (index 9) filled with 16'hFFFF for invalid sel paths
        for (i = 0; i < 9; i = i + 1) begin
            level[0][i] = inputs_arr[i];
        end
        level[0][9] = 16'hFFFF; // pad with all ones to handle uneven inputs
        for (i = 10; i < 16; i = i +1) begin
            level[0][i] = 16'hFFFF; // rest padded with all ones
        end

        // Build hierarchical mux levels
        // Each level halves the elements of previous level (rounded up)
        integer prev_count = 16; // start with padded 16 elements for convenience
        integer curr_count;
        integer j;

        // Levels 1 to MAX_LEVELS
        for (idx = 1; idx <= MAX_LEVELS; idx = idx + 1) begin
            curr_count = (prev_count + 1) >> 1; // half rounded up
            for (j = 0; j < curr_count; j = j + 1) begin
                // Compute bit index of sel to use (idx-1)
                // If sel bit index exceeds 3, use 0 (safe for unused bits)
                integer bit_idx = idx - 1;
                reg sel_bit;
                if (bit_idx <= 3)
                    sel_bit = sel[bit_idx];
                else
                    sel_bit = 1'b0;
                // Mux two elements from previous level or use padded value if out of range
                reg [15:0] in0, in1;
                in0 = level[idx-1][j*2];
                if ((j*2 + 1) < prev_count)
                    in1 = level[idx-1][j*2 + 1];
                else
                    in1 = 16'hFFFF; // pad
                level[idx][j] = sel_bit ? in1 : in0;
            end
            prev_count = curr_count;
        end

        // After MAX_LEVELS, level[MAX_LEVELS][0] holds mux result of padded inputs

        // Now, if sel >= 9 (0x9 to 0xF), output 16'hFFFF
        // Else output mux result corresponding to sel

        if (sel < 4'd9)
            out = level[MAX_LEVELS][0];
        else
            out = 16'hFFFF;
    end

endmodule