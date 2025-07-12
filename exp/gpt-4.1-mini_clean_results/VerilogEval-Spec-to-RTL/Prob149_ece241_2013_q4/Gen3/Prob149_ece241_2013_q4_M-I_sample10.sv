module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Water levels encoded to reflect actual ascending water height
localparam LEVEL_BELOW    = 2'd0; // no sensors asserted
localparam LEVEL_BETWEEN1 = 2'd1; // only s[0] asserted
localparam LEVEL_BETWEEN2 = 2'd2; // s[0] and s[1] asserted
localparam LEVEL_ABOVE    = 2'd3; // s[0], s[1], and s[2] asserted

reg [1:0] prev_level;
reg [1:0] curr_level;

// Decode current water level from exact sensor pattern
always @(*) begin
    case (s)
        3'b111: curr_level = LEVEL_ABOVE;      // Above s[2]
        3'b011: curr_level = LEVEL_BETWEEN2;   // Between s[2] and s[1]
        3'b001: curr_level = LEVEL_BETWEEN1;   // Between s[1] and s[0]
        3'b000: curr_level = LEVEL_BELOW;      // Below s[0]
        default: curr_level = LEVEL_BELOW;     // Treat other patterns conservatively as lowest
    endcase
end

wire rising = (curr_level > prev_level);

always @(posedge clk) begin
    if (reset) begin
        prev_level <= LEVEL_BELOW;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_level <= curr_level;

        // Nominal flow valves assigned per water level table
        case (curr_level)
            LEVEL_ABOVE: begin // Above s[2]: no flow valves open
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            LEVEL_BETWEEN2: begin // Between s[2] and s[1]: fr0 open
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            LEVEL_BETWEEN1: begin // Between s[1] and s[0]: fr0 and fr1 open
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            LEVEL_BELOW: begin // Below s[0]: fr0, fr1, fr2 open
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
        endcase

        // Supplemental flow valve opens only if level is rising
        dfr <= rising ? 1'b1 : 1'b0;
    end
end

endmodule