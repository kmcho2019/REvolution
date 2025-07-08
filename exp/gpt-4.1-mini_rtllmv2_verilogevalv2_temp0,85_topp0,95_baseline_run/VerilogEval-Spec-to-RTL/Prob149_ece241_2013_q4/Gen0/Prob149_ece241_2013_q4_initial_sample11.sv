module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define water level states as 2-bit codes for simplicity:
// 0 = Below s[0]
// 1 = Between s[1] and s[0]
// 2 = Between s[2] and s[1]
// 3 = Above s[2]
reg [1:0] curr_level;
reg [1:0] prev_level;

wire [1:0] decoded_level;

// Decode sensor inputs into water level
// According to sensor assertion:
// s = 3'b111 -> Above s[2] (3)
// s = 3'b011 -> Between s[2] and s[1] (2)
// s = 3'b001 -> Between s[1] and s[0] (1)
// s = 3'b000 -> Below s[0] (0)
// For any other combinations, treat as below s[0] (0).
// This covers all valid states specified.
assign decoded_level = (s == 3'b111) ? 2'd3 :
                       (s == 3'b011) ? 2'd2 :
                       (s == 3'b001) ? 2'd1 :
                       (s == 3'b000) ? 2'd0 :
                       2'd0;  // default to below s[0]

always @(posedge clk) begin
    if (reset) begin
        // Reset state: assume water level low for long time
        // so no sensors asserted, all valves asserted
        curr_level <= 2'd0;
        prev_level <= 2'd0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update levels
        prev_level <= curr_level;
        curr_level <= decoded_level;

        // Determine nominal flow outputs based on current level
        case (decoded_level)
            2'd3: begin
                // Above s[2]: no flow valves
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd2: begin
                // Between s[2] and s[1]: fr0 only
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd1: begin
                // Between s[1] and s[0]: fr0, fr1
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            2'd0: begin
                // Below s[0]: fr0, fr1, fr2
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                // Should not happen, but default to all valves on
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
        endcase

        // Determine supplemental valve dfr:
        // Assert if level increased compared to previous level
        if (curr_level > prev_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;
    end
end

endmodule