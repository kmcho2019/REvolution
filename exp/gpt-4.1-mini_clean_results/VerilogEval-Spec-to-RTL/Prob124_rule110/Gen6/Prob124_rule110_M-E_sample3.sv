module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extend q with zero bits at boundaries for left and right shifts
    wire [512:0] q_left_ext  = {q, 1'b0};   // q shifted left by 1 bit with 0 at LSB (right neighbor)
    wire [512:0] q_right_ext = {1'b0, q};   // q shifted right by 1 bit with 0 at MSB (left neighbor)

    // Extract left, center, right neighbors for all cells as 512-bit vectors
    // Note:
    // left[i]   = q[i+1] or zero if i=511 (right neighbor in spatial terms)
    // center[i] = q[i]
    // right[i]  = q[i-1] or zero if i=0 (left neighbor in spatial terms)
    wire [511:0] left   = q_left_ext [511:0];   // q shifted left by 1 with zero at right boundary
    wire [511:0] center = q;
    wire [511:0] right  = q_right_ext[510:0];   // q shifted right by 1 with zero at left boundary
    assign right = q_right_ext[511:0][511:0]; // ensure 512-bit bus (careful with indexing)

    // The last line needs adjustment:
    // q_right_ext is 513 bits wide: bits [512:0]
    // right = q_right_ext[511:0] shifted right by 1, i.e. bits [510:0] zero-padded at MSB
    // So to get 512 bits aligned:
    // right = q_right_ext[511:0]
    // But that is q shifted right by 1 with zero padded on MSB
    // Actually q_right_ext = {1'b0, q}  --> q_right_ext[512] = 0, q_right_ext[511:0] = q
    // So q_right_ext[511:0] is q, but we need to shift right by 1 bit to get right neighbor vector
    // Instead, assign right = q_right_ext[511:0], then shift:
    // So better to do:
    // wire [511:0] right = q_right_ext[511:0] >> 1;
    // but shifts by variable amounts are not synthesizable; better to slice:
    // right = q_right_ext[511:0] shifted right by 1 means bits [510:0] with zero at MSB:
    // So:
    // right = q_right_ext[511:0] with q_right_ext[0] at LSB ignored
    // Or, just do:
    wire [511:0] right = q_right_ext[511:0] >> 1; // This should be okay as q_right_ext is wider.

    // Implement the Rule 110 vectorized:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_q = ((~left) & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule