module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Reference scancodes stored as a 4x16 LUT
    wire [15:0] ref_scancodes [0:3];
    assign ref_scancodes[0] = 16'he06b; // left
    assign ref_scancodes[1] = 16'he072; // down
    assign ref_scancodes[2] = 16'he074; // right
    assign ref_scancodes[3] = 16'he075; // up

    // Shared comparator with multiplexed references
    wire [3:0] match;
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : comp_loop
            assign match[i] = (scancode == ref_scancodes[i]);
        end
    endgenerate

    // Priority encoder (left has highest priority)
    wire [1:0] sel;
    assign sel[1] = match[2] | match[3];
    assign sel[0] = match[1] | match[3];

    // One-hot output decoder
    assign left  = match[0];
    assign down  = match[1] & ~match[0];
    assign right = match[2] & ~(|match[1:0]);
    assign up    = match[3] & ~(|match[2:0]);

endmodule