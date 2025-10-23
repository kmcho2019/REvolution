module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters for grouping
    localparam GROUP_SIZE = 4;    // group bits per partial reduction
    localparam NUM_GROUPS = (100 + GROUP_SIZE - 1) / GROUP_SIZE; // Ceiling division = 25

    // --- Level 1 partial reductions (25 groups) ---
    wire [NUM_GROUPS-1:0] and_lvl1;
    wire [NUM_GROUPS-1:0] or_lvl1;
    wire [NUM_GROUPS-1:0] xor_lvl1;

    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : level1_reduce
            // Calculate slice range carefully for last group which may have <4 bits
            localparam integer start_bit = i * GROUP_SIZE;
            localparam integer bits_left = 100 - start_bit;
            localparam integer slice_width = (bits_left >= GROUP_SIZE) ? GROUP_SIZE : bits_left;

            // Extract the slice
            wire [slice_width-1:0] slice = in[start_bit +: slice_width];

            // Reduction for group (using built-in reductions)
            assign and_lvl1[i] = &slice;
            assign or_lvl1[i]  = |slice;
            assign xor_lvl1[i] = ^slice;
        end
    endgenerate

    // Define a function to perform a balanced binary tree reduction for arbitrary vector
    // This function generates combinational logic reducing input vector by & | ^ in balanced pairs
    // We implement these reductions using generate statements at each level.

    // Helper macro to reduce vectors by 2-input gates iteratively until one output remains
    // We do this separately for AND, OR, XOR signals.

    // Reduction for AND
    function automatic wire and_reduce;
        input wire [NUM_GROUPS-1:0] data_in;
        integer length, j;
        reg [NUM_GROUPS-1:0] temp [0:31]; // 32 max levels support
        reg [NUM_GROUPS-1:0] current_level;
        reg [31:0] level_idx;
        begin
            length = NUM_GROUPS;
            temp[0] = data_in;
            level_idx = 0;

            // Loop to do balanced pairwise reductions until one bit remains
            while (length > 1) begin
                for (j = 0; j < length/2; j = j + 1) begin
                    temp[level_idx + 1][j] = temp[level_idx][2*j] & temp[level_idx][2*j + 1];
                end
                if (length % 2 == 1) begin
                    temp[level_idx + 1][length/2] = temp[level_idx][length - 1];
                    length = length/2 + 1;
                end else begin
                    length = length/2;
                end
                level_idx = level_idx + 1;
            end
            and_reduce = temp[level_idx][0];
        end
    endfunction

    // Reduction for OR
    function automatic wire or_reduce;
        input wire [NUM_GROUPS-1:0] data_in;
        integer length, j;
        reg [NUM_GROUPS-1:0] temp [0:31];
        reg [31:0] level_idx;
        begin
            length = NUM_GROUPS;
            temp[0] = data_in;
            level_idx = 0;

            while (length > 1) begin
                for (j = 0; j < length/2; j = j + 1) begin
                    temp[level_idx + 1][j] = temp[level_idx][2*j] | temp[level_idx][2*j + 1];
                end
                if (length % 2 == 1) begin
                    temp[level_idx + 1][length/2] = temp[level_idx][length - 1];
                    length = length/2 + 1;
                end else begin
                    length = length/2;
                end
                level_idx = level_idx + 1;
            end
            or_reduce = temp[level_idx][0];
        end
    endfunction

    // Reduction for XOR
    function automatic wire xor_reduce;
        input wire [NUM_GROUPS-1:0] data_in;
        integer length, j;
        reg [NUM_GROUPS-1:0] temp [0:31];
        reg [31:0] level_idx;
        begin
            length = NUM_GROUPS;
            temp[0] = data_in;
            level_idx = 0;

            while (length > 1) begin
                for (j = 0; j < length/2; j = j + 1) begin
                    temp[level_idx + 1][j] = temp[level_idx][2*j] ^ temp[level_idx][2*j + 1];
                end
                if (length % 2 == 1) begin
                    temp[level_idx + 1][length/2] = temp[level_idx][length - 1];
                    length = length/2 + 1;
                end else begin
                    length = length/2;
                end
                level_idx = level_idx + 1;
            end
            xor_reduce = temp[level_idx][0];
        end
    endfunction

    // Since functions cannot have for loops with variable bounds for hardware synthesis,
    // instead we implement a procedural combinational block to do balanced reduction
    // for each output independently, using intermediate registers.

    // Reg/wire for outputs
    wire and_out, or_out, xor_out;

    // We'll implement balanced tree reduction in combinational always_comb blocks

    // Helper task to perform balanced reduction for arbitrary input vector
    // but Verilog does not allow variable sized vectors in tasks easily
    // So we implement this as a localparam max input size 25

    // We implement a combinational process to do the balanced reduction of each signal

    reg and_tree [0:31][0:24]; // levels max 32, elements max 25
    reg or_tree  [0:31][0:24];
    reg xor_tree [0:31][0:24];

    integer level, index, len;

    always @(*) begin
        // Initialize level 0 with partial group signals
        for (index = 0; index < NUM_GROUPS; index = index + 1) begin
            and_tree[0][index] = and_lvl1[index];
            or_tree[0][index]  = or_lvl1[index];
            xor_tree[0][index] = xor_lvl1[index];
        end

        len = NUM_GROUPS;
        level = 0;

        // Balanced tree reduction
        while (len > 1) begin
            for (index = 0; index < len/2; index = index + 1) begin
                and_tree[level + 1][index] = and_tree[level][2*index] & and_tree[level][2*index + 1];
                or_tree[level + 1][index]  = or_tree[level][2*index] | or_tree[level][2*index + 1];
                xor_tree[level + 1][index] = xor_tree[level][2*index] ^ xor_tree[level][2*index + 1];
            end
            if (len % 2 == 1) begin
                and_tree[level + 1][len/2] = and_tree[level][len - 1];
                or_tree[level + 1][len/2]  = or_tree[level][len - 1];
                xor_tree[level + 1][len/2] = xor_tree[level][len - 1];
                len = len/2 + 1;
            end else begin
                len = len/2;
            end
            level = level + 1;
        end
    end

    assign out_and = and_tree[level][0];
    assign out_or  = or_tree[level][0];
    assign out_xor = xor_tree[level][0];

endmodule