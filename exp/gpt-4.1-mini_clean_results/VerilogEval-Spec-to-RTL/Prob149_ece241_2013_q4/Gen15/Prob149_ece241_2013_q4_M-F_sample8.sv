module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water levels encoding
    // 0 = BELOW (no sensors asserted)
    // 1 = LOW   (only lowest sensor s[0] asserted)
    // 2 = MID   (lowest s[0] and middle s[1] asserted)
    // 3 = ABOVE (all three sensors s[0], s[1], s[2] asserted)
    // Decode contiguous asserted sensors from bottom up
    function [1:0] decode_level;
        input [2:0] s_in;
        begin
            if (s_in[0] == 1'b0)
                decode_level = 2'd0; // no sensor asserted => BELOW
            else if (s_in[1] == 1'b0)
                decode_level = 2'd1; // only lowest sensor asserted => LOW
            else if (s_in[2] == 1'b0)
                decode_level = 2'd2; // lowest and middle asserted => MID
            else
                decode_level = 2'd3; // all sensors asserted => ABOVE
        end
    endfunction

    reg [1:0] curr_level, prev_level;
    wire [1:0] next_level = decode_level(s);

    wire level_changed = (next_level != curr_level);

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0; // BELOW on reset
            prev_level <= 2'd0; // BELOW on reset
        end else begin
            if (level_changed)
                prev_level <= curr_level;
            curr_level <= next_level;
        end
    end

    // Nominal flow outputs combinational based on curr_level
    // ABOVE (3): fr2=0, fr1=0, fr0=0
    // MID   (2): fr2=0, fr1=0, fr0=1
    // LOW   (1): fr2=0, fr1=1, fr0=1
    // BELOW (0): fr2=1, fr1=1, fr0=1
    always @(*) begin
        case (curr_level)
            2'd3: begin // ABOVE
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
            end
            2'd2: begin // MID
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
            end
            2'd1: begin // LOW
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            default: begin // BELOW or any other unrecognized pattern
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
        endcase
    end

    // Supplemental flow valve dfr synchronous logic
    // dfr asserted whenever curr_level > prev_level (water level above previous)
    // Deasserted otherwise
    always @(posedge clk) begin
        if (reset) begin
            dfr <= 1'b1; // asserted on reset per spec
        end else begin
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule