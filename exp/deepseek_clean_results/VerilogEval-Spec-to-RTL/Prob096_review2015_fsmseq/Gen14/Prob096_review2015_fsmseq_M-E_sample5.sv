module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Level 1: First '1' detection
    reg level1;
    wire level1_match = data;

    // Level 2: Second '1' detection (following first '1')
    reg level2;
    wire level2_match = level1 && data;

    // Level 3: '0' detection (following '11')
    reg level3;
    wire level3_match = level2 && !data;

    // Level 4: Final '1' detection (following '110')
    reg level4;
    wire level4_match = level3 && data;

    // Found flag (latches permanently)
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            level1 <= 1'b0;
            level2 <= 1'b0;
            level3 <= 1'b0;
            level4 <= 1'b0;
            found <= 1'b0;
        end else if (!found) begin
            // Update each level only if previous levels matched
            level1 <= level1_match;
            level2 <= level2_match;
            level3 <= level3_match;
            level4 <= level4_match;
            found <= level4_match;
        end
    end

    assign start_shifting = found;

endmodule