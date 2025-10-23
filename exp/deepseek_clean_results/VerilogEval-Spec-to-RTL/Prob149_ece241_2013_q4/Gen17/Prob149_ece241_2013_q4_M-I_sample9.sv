module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;  // Previous sensor state
    reg [1:0] curr_level, prev_level; // Encoded water levels

    // Water level encoding:
    // 00 - Below s[0] (no sensors)
    // 01 - Between s[1]-s[0] (s[0] only)
    // 10 - Between s[2]-s[1] (s[0],s[1])
    // 11 - Above s[2] (all sensors)

    always @(*) begin
        casez(s)
            3'b000: curr_level = 2'b00; // Below s[0]
            3'b001: curr_level = 2'b01; // Between s[1]-s[0]
            3'b011: curr_level = 2'b10; // Between s[2]-s[1]
            3'b111: curr_level = 2'b11; // Above s[2]
            default: curr_level = 2'b00; // Invalid -> treat as below
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Reset state: all outputs high (maximum flow)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_level <= 2'b00;  // Assume was below s[0]
        end else begin
            // Store previous level
            prev_level <= curr_level;

            // Flow rate outputs
            fr0 <= (curr_level != 2'b11); // On unless above s[2]
            fr1 <= (curr_level == 2'b01) || (curr_level == 2'b00); // Between s[1]-s[0] or below
            fr2 <= (curr_level == 2'b00); // Only when below s[0]

            // DFR (supplemental flow) when water is rising
            dfr <= (curr_level > prev_level);
        end
    end

endmodule