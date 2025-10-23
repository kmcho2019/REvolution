module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pad the state with zeros at boundaries: left pad zero + q + right pad zero
    reg [513:0] q_pad_stage1;
    reg [513:0] q_pad_stage2;  // Pipeline stage 2 for next state calculation

    // Next state computed from padded q_pad_stage1
    wire [511:0] next_state;

    // Rule 110 lookup table implemented as a function
    // Inputs: left, center, right (bits)
    // Output: next state bit
    function automatic rule110;
        input left, center, right;
        begin
            // Rule110 truth table (from problem):
            // Left Center Right -> Next
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            // This matches the boolean function:
            // next = (~left & center) | (center ^ right)
            rule110 = (~left & center) | (center ^ right);
        end
    endfunction

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            // neighbors in padded vector:
            // left neighbor: q_pad_stage1[i+2]
            // center:        q_pad_stage1[i+1]
            // right neighbor:q_pad_stage1[i]

            assign next_state[i] = rule110(
                q_pad_stage1[i+2],
                q_pad_stage1[i+1],
                q_pad_stage1[i]
            );
        end
    endgenerate

    // Pipeline registers:
    // Stage 1: load input data (with padding) into q_pad_stage1 or hold current q padded with zeros
    always @(posedge clk) begin
        if (load) begin
            // Load input data with zero padding
            q_pad_stage1 <= {1'b0, data, 1'b0};
        end else begin
            // Pad current q with zeros at boundaries
            q_pad_stage1 <= {1'b0, q, 1'b0};
        end
    end

    // Stage 2: compute next state in next_state wire from q_pad_stage1 and register it as q_pad_stage2
    always @(posedge clk) begin
        if (load) begin
            // When loading, bypass next state update pipeline stage 2; keep q_pad_stage2 aligned with input data
            q_pad_stage2 <= {1'b0, data, 1'b0};
        end else begin
            q_pad_stage2 <= {1'b0, next_state, 1'b0};
        end
    end

    // Output register q updated from the middle 512 bits of q_pad_stage2 (removing padding)
    always @(posedge clk) begin
        if (load) begin
            q <= data; // direct load
        end else begin
            q <= q_pad_stage2[512:1];
        end
    end

endmodule