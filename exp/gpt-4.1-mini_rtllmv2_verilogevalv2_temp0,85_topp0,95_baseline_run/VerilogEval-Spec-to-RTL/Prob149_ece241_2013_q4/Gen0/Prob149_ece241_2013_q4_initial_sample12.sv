module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire [2:0] s,
    output reg        fr2,
    output reg        fr1,
    output reg        fr0,
    output reg        dfr
);

    // Represent sensor level as number of sensors asserted from bottom up:
    // Level 0: no sensors asserted (below s[0])
    // Level 1: s[0] asserted only
    // Level 2: s[0] and s[1] asserted (between s[2] and s[1])
    // Level 3: all three asserted (above s[2])

    // To compute current level:
    // level 3 if s == 3'b111
    // level 2 if s[0]==1 and s[1]==1 and s[2]==0
    // level 1 if s[0]==1 and s[1]==0 and s[2]==0
    // level 0 otherwise

    reg [1:0] prev_level, curr_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to low water level for a long time (no sensors asserted)
            // All outputs asserted (fr0, fr1, fr2, dfr)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_level <= 2'd0;
        end else begin
            // Determine current level
            if (s == 3'b111) 
                curr_level = 2'd3;       // above s[2]
            else if (s[0] && s[1] && ~s[2]) 
                curr_level = 2'd2;       // between s[2] and s[1]
            else if (s[0] && ~s[1] && ~s[2]) 
                curr_level = 2'd1;       // between s[1] and s[0]
            else 
                curr_level = 2'd0;       // below s[0]
            
            // Determine nominal flow outputs and supplemental flow (dfr)
            // Based on table:
            // Above s[2]: no nominal flow (fr0..2=0), dfr=0
            // Between s[2] and s[1]: fr0=1, fr1=0, fr2=0
            // Between s[1] and s[0]: fr0=1, fr1=1, fr2=0
            // Below s[0]: fr0=1, fr1=1, fr2=1
            // dfr asserted if prev_level < curr_level (water rising)
            
            case (curr_level)
                2'd3: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                2'd2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                2'd1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                2'd0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                default: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase

            dfr <= (prev_level < curr_level) ? 1'b1 : 1'b0;

            prev_level <= curr_level;
        end
    end

endmodule