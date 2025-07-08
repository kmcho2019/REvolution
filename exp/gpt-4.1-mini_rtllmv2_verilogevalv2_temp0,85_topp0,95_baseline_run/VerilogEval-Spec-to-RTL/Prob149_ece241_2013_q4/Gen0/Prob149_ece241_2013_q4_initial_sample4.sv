module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output reg    fr2,
    output reg    fr1,
    output reg    fr0,
    output reg    dfr
);

// Water level encoding:
// 0 = none asserted (below s[0])
// 1 = only s[0] asserted
// 2 = s[0] and s[1] asserted
// 3 = all three asserted (above s[2])

reg [1:0] prev_level;
reg [1:0] curr_level;

function [1:0] get_level(input [2:0] sensors);
    begin
        // Check for all sensors asserted
        if (sensors == 3'b111)
            get_level = 2'd3;
        else if (sensors[1] && sensors[0] && !sensors[2])
            get_level = 2'd2;
        else if (sensors[0] && !sensors[1] && !sensors[2])
            get_level = 2'd1;
        else if (!sensors[0] && !sensors[1] && !sensors[2])
            get_level = 2'd0;
        else begin
            // Handle any other unexpected combinations by mapping to closest lower level:
            // For example, if s[2] only or s[1] only asserted, treat as below s[0].
            // But per problem description, sensors are placed vertically and water level should be consistent,
            // so these cases are unlikely.
            // We treat such cases as 0 (lowest level)
            get_level = 2'd0;
        end
    end
endfunction

// Compute nominal flow outputs based on current water level
// According to the table:
// level 3 (above s2): no flow valves open (fr0=0, fr1=0, fr2=0)
// level 2 (between s2 and s1): fr0=1, fr1=0, fr2=0
// level 1 (between s1 and s0): fr0=1, fr1=1, fr2=0
// level 0 (below s0): fr0=1, fr1=1, fr2=1

always @(posedge clk) begin
    if (reset) begin
        prev_level <= 2'd0; // reset to lowest level
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1; // supplemental valve open at reset (per description)
    end else begin
        curr_level = get_level(s);

        // Assign nominal flow valves according to curr_level
        case (curr_level)
            2'd3: begin // above s2
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd2: begin // between s2 and s1
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            2'd1: begin // between s1 and s0
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            2'd0: begin // below s0
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
        endcase

        // Supplemental flow valve (dfr) open if water level rising compared to previous level
        if (curr_level > prev_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        // update previous level
        prev_level <= curr_level;
    end
end

endmodule