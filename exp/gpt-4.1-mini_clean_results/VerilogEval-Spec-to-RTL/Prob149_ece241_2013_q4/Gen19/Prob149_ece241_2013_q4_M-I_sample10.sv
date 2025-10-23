module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Encoding water levels:
    // 0 = LOW (below s[0]) = no sensors asserted (000)
    // 1 = MEDIUM_LOW (between s[1] and s[0]) = s[0] only (001)
    // 2 = MEDIUM_HIGH (between s[2] and s[1]) = s[1] and s[0] asserted (011)
    // 3 = HIGH (above s[2]) = all sensors asserted (111)

    // Decode sensor input to water level
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_level = 2'd0; // LOW
                3'b001: decode_level = 2'd1; // MEDIUM_LOW
                3'b011: decode_level = 2'd2; // MEDIUM_HIGH
                3'b111: decode_level = 2'd3; // HIGH
                default: decode_level = 2'd0; // Treat any other case as LOW (safe fallback)
            endcase
        end
    endfunction

    wire [1:0] sampled_level = decode_level(s);

    reg [1:0] current_level;
    reg [1:0] prev_level;
    reg [1:0] prev_prev_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset state as if water level had been low for long (no sensors, all flow outputs asserted)
            current_level   <= 2'd0;
            prev_level      <= 2'd0;
            prev_prev_level <= 2'd0;
            dfr             <= 1'b1; // Supplemental valve open on reset as per spec
        end else begin
            if (sampled_level != current_level) begin
                // Update two-level history on sensor change
                prev_prev_level <= prev_level;
                prev_level      <= current_level;
                current_level   <= sampled_level;

                // dfr asserted when water level rises compared to prev_prev_level
                dfr <= (sampled_level > prev_prev_level);
            end else begin
                dfr <= 1'b0; // dfr only pulsed one clock on rising level change
            end
        end
    end

    // Nominal flow outputs combinationally assigned from current_level:
    // Above s[2] (level 3): no nominal flow valves asserted
    // Between s[2] and s[1] (level 2): fr0 only
    // Between s[1] and s[0] (level 1): fr0 and fr1
    // Below s[0] (level 0): fr0, fr1, fr2

    assign fr0 = (current_level <= 2'd2);
    assign fr1 = (current_level <= 2'd1);
    assign fr2 = (current_level == 2'd0);

endmodule