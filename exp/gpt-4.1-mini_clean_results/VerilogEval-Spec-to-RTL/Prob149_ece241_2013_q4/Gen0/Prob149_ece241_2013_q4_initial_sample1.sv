module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define water level encoding
// 0 = Below s[0]      (s == 3'b000)
// 1 = Between s[1],s[0] (s == 3'b001)
// 2 = Between s[2],s[1] (s == 3'b011)
// 3 = Above s[2]        (s == 3'b111)

// Function to decode sensor input to level
function [1:0] decode_level;
    input [2:0] sensors;
    begin
        case (sensors)
            3'b000: decode_level = 2'd0; // below s[0]
            3'b001: decode_level = 2'd1; // between s[1], s[0]
            3'b011: decode_level = 2'd2; // between s[2], s[1]
            3'b111: decode_level = 2'd3; // above s[2]
            3'b010: decode_level = 2'd1; // s[1] only asserted, treat as between s[1],s[0] (closest known)
            3'b100: decode_level = 2'd2; // s[2] only asserted, treat as between s[2], s[1]
            3'b101: decode_level = 2'd3; // s[2], s[0] asserted but s[1] not, treat as above s[2] conservatively
            3'b110: decode_level = 2'd3; // s[2], s[1] asserted, treat as above s[2]
            default: decode_level = 2'd0; // default to below s[0]
        endcase
    end
endfunction

reg [1:0] previous_level;
reg [1:0] current_level;

always @(posedge clk) begin
    if (reset) begin
        // reset to lowest level, all outputs asserted
        current_level <= 2'd0; // below s[0]
        previous_level <= 2'd0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        current_level <= decode_level(s);
        // Set fr outputs based on current_level (nominal flow)
        case (decode_level(s))
            2'd3: begin
                // Above s[2], no flow
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd2: begin
                // Between s[2] and s[1], fr0
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd1: begin
                // Between s[1] and s[0], fr0 and fr1
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            2'd0: begin
                // Below s[0], all three nominal flow valves open
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                // default to lowest level outputs
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
        endcase

        // dfr asserted if current_level > previous_level
        if (current_level > previous_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        previous_level <= current_level;
    end
end

endmodule