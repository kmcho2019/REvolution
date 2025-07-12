module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water levels encoding
    localparam BELOW    = 2'd0; // No sensors asserted: s=3'b000
    localparam BETWEEN0 = 2'd1; // Only lowest sensor asserted: s=3'b001
    localparam BETWEEN1 = 2'd2; // Lowest and middle sensors asserted: s=3'b011
    localparam ABOVE    = 2'd3; // All sensors asserted: s=3'b111

    // Decode sensor pattern exactly
    wire is_above    = (s == 3'b111);
    wire is_between1 = (s == 3'b011);
    wire is_between0 = (s == 3'b001);
    wire is_below    = (s == 3'b000);

    // For any other sensor patterns (e.g., partial other combinations),
    // treat as BELOW as safe fallback (per spec, only these patterns defined)
    wire [1:0] next_level = is_above    ? ABOVE    :
                           is_between1 ? BETWEEN1 :
                           is_between0 ? BETWEEN0 :
                           is_below    ? BELOW    :
                                         BELOW; // default/fallback

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    wire level_changed = (next_level != curr_level);
    wire rising        = level_changed && (next_level > curr_level);

    // State updates synchronous
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW;
            prev_level <= BELOW;
        end else begin
            if (level_changed) prev_level <= curr_level;
            curr_level <= next_level;
        end
    end

    // Nominal flow logic combinational from curr_level
    reg fr0_r, fr1_r, fr2_r;

    always @(*) begin
        case (curr_level)
            ABOVE: begin
                fr0_r = 1'b0;
                fr1_r = 1'b0;
                fr2_r = 1'b0;
            end
            BETWEEN1: begin
                fr0_r = 1'b1;
                fr1_r = 1'b0;
                fr2_r = 1'b0;
            end
            BETWEEN0: begin
                fr0_r = 1'b1;
                fr1_r = 1'b1;
                fr2_r = 1'b0;
            end
            BELOW: begin
                fr0_r = 1'b1;
                fr1_r = 1'b1;
                fr2_r = 1'b1;
            end
            default: begin
                // Defensive default to all open
                fr0_r = 1'b1;
                fr1_r = 1'b1;
                fr2_r = 1'b1;
            end
        endcase
    end

    // dfr logic synchronous (updated only on rising condition)
    reg dfr_r;
    always @(posedge clk) begin
        if (reset) begin
            dfr_r <= 1'b1;
        end else begin
            dfr_r <= rising;
        end
    end

    // Outputs synchronous registered, active-high.
    // During reset, all asserted per spec (max flow).
    assign fr0 = reset ? 1'b1 : fr0_r;
    assign fr1 = reset ? 1'b1 : fr1_r;
    assign fr2 = reset ? 1'b1 : fr2_r;
    assign dfr = reset ? 1'b1 : dfr_r;

endmodule