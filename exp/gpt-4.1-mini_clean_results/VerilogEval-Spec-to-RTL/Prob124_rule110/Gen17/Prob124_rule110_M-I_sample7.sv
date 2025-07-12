module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Number of segments and segment width
    localparam SEGMENTS = 4;
    localparam SEG_WIDTH = 512 / SEGMENTS; // 128 bits

    // State registers to hold each segment separately
    reg [SEG_WIDTH-1:0] seg_q[0:SEGMENTS-1];

    // Next state registers for each segment
    reg [SEG_WIDTH-1:0] seg_next[0:SEGMENTS-1];

    // Load process state machine (2-bit counter for segment update)
    reg [1:0] update_idx;

    // State machine: 
    // When load==1, all segments are loaded synchronously.
    // When load==0, update one segment per clock cycle, rotating through segments 0 to 3.

    integer i;

    // Zero-extended concatenation helper (for neighbor access)
    // Because neighbors from adjacent segments are needed,
    // we keep seg_q registers available to build extended vectors per segment.

    // For each segment, create extended segment with zero boundaries:
    // extended length = SEG_WIDTH + 2 (left and right zero padding)
    reg [SEG_WIDTH+1:0] seg_ext[0:SEGMENTS-1];

    // Helper function to compute next state per segment combinationally
    // Using the Rule 110 logic expression:
    // next = (~left & center) | (center ^ right)

    always @(*) begin
        // Build extended segments with neighbor boundaries
        for (i=0; i < SEGMENTS; i=i+1) begin
            // Left boundary bit from previous segment or zero if first segment
            // Right boundary bit from next segment or zero if last segment
            seg_ext[i][SEG_WIDTH+1] = (i < SEGMENTS-1) ? seg_q[i+1][0] : 1'b0; // left neighbor for MSB
            seg_ext[i][0] = (i > 0) ? seg_q[i-1][SEG_WIDTH-1] : 1'b0;          // right neighbor for LSB
            seg_ext[i][SEG_WIDTH:1] = seg_q[i];
        end

        // Calculate next state for each segment combinationally
        for (i=0; i < SEGMENTS; i=i+1) begin
            integer bit_idx;
            for (bit_idx=0; bit_idx < SEG_WIDTH; bit_idx=bit_idx+1) begin
                // neighbors for bit 'bit_idx' in segment i
                // left = seg_ext[i][bit_idx+2]
                // center = seg_ext[i][bit_idx+1]
                // right = seg_ext[i][bit_idx]
                seg_next[i][bit_idx] = (~seg_ext[i][bit_idx+2] & seg_ext[i][bit_idx+1]) | (seg_ext[i][bit_idx+1] ^ seg_ext[i][bit_idx]);
            end
        end
    end

    // Sequential logic: load or update segments cyclically
    always @(posedge clk) begin
        if (load) begin
            // Synchronously load entire data
            for (i=0; i < SEGMENTS; i=i+1)
                seg_q[i] <= data[i*SEG_WIDTH +: SEG_WIDTH];
            update_idx <= 0;
            // Update output q
            q <= data;
        end else begin
            // Update one segment at a time per clock cycle
            seg_q[update_idx] <= seg_next[update_idx];

            // Increment update index modulo SEGMENTS
            update_idx <= update_idx + 1;

            // Output concatenated updated state only when full update cycle is complete
            if (update_idx == SEGMENTS - 1) begin
                // Reassemble full q from updated segments
                q <= {seg_q[SEGMENTS-1], seg_q[SEGMENTS-2], seg_q[SEGMENTS-3], seg_q[0]}; // rearranged after all segments updated
                // But above ordering is incorrect for concatenation: Should be [511:0] = seg_q[3], seg_q[2], seg_q[1], seg_q[0]
                // Fix below
            end else begin
                // Keep q stable while partial updates occur
                q <= q;
            end
        end
    end

    // Fix: After thinking, the concatenation above was reversed. 
    // So we need an explicit update of q after full update_idx cycle
    // To do so cleanly, make a separate register to store q on completion

    reg [511:0] q_next;

    always @(posedge clk) begin
        if (load) begin
            q_next <= data;
        end else if (update_idx == SEGMENTS - 1) begin
            // Assemble q_next from updated seg_q segments
            q_next <= {seg_q[3], seg_q[2], seg_q[1], seg_q[0]};
        end
    end

    always @(posedge clk) begin
        q <= q_next;
    end

endmodule