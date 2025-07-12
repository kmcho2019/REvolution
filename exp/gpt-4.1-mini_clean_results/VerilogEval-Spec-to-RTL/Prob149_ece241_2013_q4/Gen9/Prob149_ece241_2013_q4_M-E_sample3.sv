module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding:
    // 0 = below s[0]    (no sensors asserted)
    // 1 = between s[1] and s[0] (only s[0] asserted)
    // 2 = between s[2] and s[1] (s[0] and s[1] asserted)
    // 3 = above s[2]    (all sensors asserted)

    // Decode sensor input to contiguous water level integer [0..3]
    function automatic [1:0] decode_level(input [2:0] sensors);
        begin
            // Enforce contiguous from bottom up: valid patterns are 3'b000, 001, 011, 111
            // If invalid, normalize downwards by clearing upper bits until valid
            if (sensors[0] == 0) begin
                // s0 not asserted => level 0
                decode_level = 2'd0;
            end else if (sensors[1] == 0) begin
                // only s0 asserted
                decode_level = 2'd1;
            end else if (sensors[2] == 0) begin
                // s0 and s1 asserted
                decode_level = 2'd2;
            end else begin
                // all sensors asserted
                decode_level = 2'd3;
            end
        end
    endfunction

    reg [1:0] current_level, last_level_on_change;
    reg [1:0] prev_level;

    // Decode sensors each cycle
    wire [1:0] decoded_level = decode_level(s);

    always @(posedge clk) begin
        if (reset) begin
            current_level      <= 2'd0; // lowest level on reset
            last_level_on_change <= 2'd0;
            prev_level         <= 2'd0;
        end else begin
            prev_level   <= current_level;
            current_level <= decoded_level;

            // Update last_level_on_change only if level changed
            if (decoded_level != current_level) begin
                // Assign previous current_level before the update
                last_level_on_change <= current_level;
            end
            // else retain last_level_on_change
        end
    end

    // Nominal flow valves logic
    // According to level:
    // level=3: fr0=0, fr1=0, fr2=0
    // level=2: fr0=1, fr1=0, fr2=0
    // level=1: fr0=1, fr1=1, fr2=0
    // level=0: fr0=1, fr1=1, fr2=1

    reg fr0_reg, fr1_reg, fr2_reg, dfr_reg;

    always @(*) begin
        // Default valves closed
        fr0_reg = 1'b0;
        fr1_reg = 1'b0;
        fr2_reg = 1'b0;
        dfr_reg = 1'b0;

        case (current_level)
            2'd3: begin
                fr0_reg = 1'b0; fr1_reg = 1'b0; fr2_reg = 1'b0;
            end
            2'd2: begin
                fr0_reg = 1'b1; fr1_reg = 1'b0; fr2_reg = 1'b0;
            end
            2'd1: begin
                fr0_reg = 1'b1; fr1_reg = 1'b1; fr2_reg = 1'b0;
            end
            2'd0: begin
                fr0_reg = 1'b1; fr1_reg = 1'b1; fr2_reg = 1'b1;
            end
            default: begin
                fr0_reg = 1'b0; fr1_reg = 1'b0; fr2_reg = 1'b0;
            end
        endcase

        // Supplemental valve dfr opens if level rose compared to last_level_on_change
        if (current_level > last_level_on_change) begin
            dfr_reg = 1'b1;
        end else begin
            dfr_reg = 1'b0;
        end
    end

    // Outputs: forced max flow on reset as required
    assign fr0 = reset ? 1'b1 : fr0_reg;
    assign fr1 = reset ? 1'b1 : fr1_reg;
    assign fr2 = reset ? 1'b1 : fr2_reg;
    assign dfr = reset ? 1'b1 : dfr_reg;

endmodule