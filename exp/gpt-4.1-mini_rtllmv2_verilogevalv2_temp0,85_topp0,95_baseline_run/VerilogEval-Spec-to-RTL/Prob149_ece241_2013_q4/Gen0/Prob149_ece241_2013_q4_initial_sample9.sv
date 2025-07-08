module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    // Function to count bits set in 3-bit vector
    function [1:0] count_ones;
        input [2:0] value;
        begin
            count_ones = value[0] + value[1] + value[2];
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to low water level for a long time: no sensors asserted, all flow outputs 1
            prev_s <= 3'b000;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Determine nominal flow rate based on current sensor inputs s
            // According to table:
            // Above s[2]: s=111 -> all outputs zero
            // Between s[2] and s[1]: s=110 -> fr0=1
            // Between s[1] and s[0]: s=100 -> fr0=1, fr1=1
            // Below s[0]: s=000 -> fr0=1, fr1=1, fr2=1

            // Default flow signals
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;

            case (s)
                3'b111: begin
                    // Above s[2], no flow
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                3'b110: begin
                    // Between s[2] and s[1]
                    fr0 <= 1'b1;
                    // dfr depends on level rising
                end
                3'b100: begin
                    // Between s[1] and s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    // dfr depends on level rising
                end
                3'b000: begin
                    // Below s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                    // dfr depends on level rising
                end
                3'b011: begin
                    // s[0]=1,s[1]=1,s[2]=0 (same as 110 in terms of sensors asserted, but reversed bits)
                    // From problem statement only exact combos given, but for safety treat as 110
                    fr0 <= 1'b1;
                end
                3'b010: begin
                    // s[1]=1 only - no direct mapping, treat conservatively
                    fr0 <= 1'b1;
                end
                3'b001: begin
                    // s[0]=1 only low sensor asserted, treat like 100
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                end
                3'b101: begin
                    // s[2] and s[0] asserted - no direct mapping, treat as between s[2] and s[1]
                    fr0 <= 1'b1;
                end
                default: begin
                    // If unexpected pattern, default to max flow (lowest)
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Determine if water level is rising: if number of asserted sensors in current s > previous s
            if (count_ones(s) > count_ones(prev_s))
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            prev_s <= s;
        end
    end

endmodule