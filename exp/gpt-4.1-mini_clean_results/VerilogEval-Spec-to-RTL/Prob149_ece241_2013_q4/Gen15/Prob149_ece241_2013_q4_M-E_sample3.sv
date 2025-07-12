module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output reg    dfr
);

    // Water levels encoded as integers for easy comparison
    // 0 = below s[0], 1 = between s[1] and s[0], 2 = between s[2] and s[1], 3 = above s[2]
    reg [1:0] current_level, prev_level;

    // Decode sensor inputs to numeric level
    // According to problem:
    //   s = 3'b000 => below s[0] => level 0
    //   s = 3'b001 => s[0] only => level 1
    //   s = 3'b011 => s[0] and s[1] => level 2
    //   s = 3'b111 => s[0], s[1], s[2] => level 3
    // Other combinations (like s[2] asserted without s[1] or s[0]) are invalid or treated as nearest lower level.
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Check from highest to lowest
            if (sensors == 3'b111) decode_level = 2'd3;
            else if (sensors == 3'b011) decode_level = 2'd2;
            else if (sensors == 3'b001) decode_level = 2'd1;
            else decode_level = 2'd0; // includes 3'b000 and any other patterns
        end
    endfunction

    wire [1:0] new_level = decode_level(s);

    // Update levels and dfr on clock
    always @(posedge clk) begin
        if (reset) begin
            // Reset: lowest level, all flows on including dfr per spec
            current_level <= 2'd0;
            prev_level <= 2'd0;
            dfr <= 1'b1;
        end else begin
            // On level change, update previous level first, then current level
            if (new_level != current_level) begin
                prev_level <= current_level;
                current_level <= new_level;
                // dfr high only if level rose (new_level > prev_level)
                dfr <= (new_level > current_level) ? 1'b1 : 1'b0;
            end
            else begin
                // maintain dfr (no level change)
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs combinationally assigned based on current_level:
    // Level = 3 (above s[2]): no nominal flow valves open (fr0=fr1=fr2=0)
    // Level = 2 (between s[2] and s[1]): fr0=1, fr1=fr2=0
    // Level = 1 (between s[1] and s[0]): fr0=1, fr1=1, fr2=0
    // Level = 0 (below s[0]): fr0=fr1=fr2=1

    assign fr0 = (current_level != 2'd3);
    assign fr1 = (current_level == 2'd1) || (current_level == 2'd0);
    assign fr2 = (current_level == 2'd0);

endmodule