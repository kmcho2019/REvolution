module BinaryTreeOperation(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Define the number of levels in the tree
    localparam NUM_LEVELS = 7;

    // Initialize variables to store the result of each operation
    reg [99:0] and_result;
    reg [99:0] or_result;
    reg [99:0] xor_result;

    // Perform AND operation using a binary tree
    reg [49:0] and_level1;
    reg [24:0] and_level2;
    reg [12:0] and_level3;
    reg [6:0] and_level4;
    reg [3:0] and_level5;
    reg [1:0] and_level6;
    reg and_level7;

    always @(in) begin
        // Level 1: 50-bit AND operations
        for (int i = 0; i < 50; i++) begin
            and_level1[i] = in[2*i] & in[2*i+1];
        end

        // Level 2: 25-bit AND operations
        for (int i = 0; i < 25; i++) begin
            and_level2[i] = and_level1[2*i] & and_level1[2*i+1];
        end

        // Level 3: 12-bit AND operations
        for (int i = 0; i < 12; i++) begin
            and_level3[i] = and_level2[2*i] & and_level2[2*i+1];
        end

        // Level 4: 6-bit AND operations
        for (int i = 0; i < 6; i++) begin
            and_level4[i] = and_level3[2*i] & and_level3[2*i+1];
        end

        // Level 5: 3-bit AND operations
        for (int i = 0; i < 3; i++) begin
            and_level5[i] = and_level4[2*i] & and_level4[2*i+1];
        end

        // Level 6: 1-bit AND operations
        and_level6[0] = and_level5[0] & and_level5[1];
        and_level6[1] = and_level5[2];

        // Level 7: Final AND operation
        and_level7 = and_level6[0] & and_level6[1];

        // Assign result to output port
        out_and = and_level7;
    end

    // Perform OR operation using a binary tree
    reg [49:0] or_level1;
    reg [24:0] or_level2;
    reg [12:0] or_level3;
    reg [6:0] or_level4;
    reg [3:0] or_level5;
    reg [1:0] or_level6;
    reg or_level7;

    always @(in) begin
        // Level 1: 50-bit OR operations
        for (int i = 0; i < 50; i++) begin
            or_level1[i] = in[2*i] | in[2*i+1];
        end

        // Level 2: 25-bit OR operations
        for (int i = 0; i < 25; i++) begin
            or_level2[i] = or_level1[2*i] | or_level1[2*i+1];
        end

        // Level 3: 12-bit OR operations
        for (int i = 0; i < 12; i++) begin
            or_level3[i] = or_level2[2*i] | or_level2[2*i+1];
        end

        // Level 4: 6-bit OR operations
        for (int i = 0; i < 6; i++) begin
            or_level4[i] = or_level3[2*i] | or_level3[2*i+1];
        end

        // Level 5: 3-bit OR operations
        for (int i = 0; i < 3; i++) begin
            or_level5[i] = or_level4[2*i] | or_level4[2*i+1];
        end

        // Level 6: 1-bit OR operations
        or_level6[0] = or_level5[0] | or_level5[1];
        or_level6[1] = or_level5[2];

        // Level 7: Final OR operation
        or_level7 = or_level6[0] | or_level6[1];

        // Assign result to output port
        out_or = or_level7;
    end

    // Perform XOR operation using a binary tree
    reg [49:0] xor_level1;
    reg [24:0] xor_level2;
    reg [12:0] xor_level3;
    reg [6:0] xor_level4;
    reg [3:0] xor_level5;
    reg [1:0] xor_level6;
    reg xor_level7;

    always @(in) begin
        // Level 1: 50-bit XOR operations
        for (int i = 0; i < 50; i++) begin
            xor_level1[i] = in[2*i] ^ in[2*i+1];
        end

        // Level 2: 25-bit XOR operations
        for (int i = 0; i < 25; i++) begin
            xor_level2[i] = xor_level1[2*i] ^ xor_level1[2*i+1];
        end

        // Level 3: 12-bit XOR operations
        for (int i = 0; i < 12; i++) begin
            xor_level3[i] = xor_level2[2*i] ^ xor_level2[2*i+1];
        end

        // Level 4: 6-bit XOR operations
        for (int i = 0; i < 6; i++) begin
            xor_level4[i] = xor_level3[2*i] ^ xor_level3[2*i+1];
        end

        // Level 5: 3-bit XOR operations
        for (int i = 0; i < 3; i++) begin
            xor_level5[i] = xor_level4[2*i] ^ xor_level4[2*i+1];
        end

        // Level 6: 1-bit XOR operations
        xor_level6[0] = xor_level5[0] ^ xor_level5[1];
        xor_level6[1] = xor_level5[2];

        // Level 7: Final XOR operation
        xor_level7 = xor_level6[0] ^ xor_level6[1];

        // Assign result to output port
        out_xor = xor_level7;
    end

endmodule