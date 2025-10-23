module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Level encoding:
    // 3: above s[2] (all sensors active)
    // 2: between s[2] and s[1] (s[1:0] active)
    // 1: between s[1] and s[0] (only s[0] active)
    // 0: below s[0] (no sensors active)
    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Level detection with proper priority
    always @(*) begin
        case (s)
            3'b111: current_level = 3; // above s[2]
            3'b011: current_level = 2; // between s[2]-s[1]
            3'b001: current_level = 1; // between s[1]-s[0]
            3'b000: current_level = 0; // below s[0]
            default: current_level = prev_level; // invalid pattern
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update previous level
            prev_level <= current_level;

            // Nominal flow outputs
            fr0 <= (current_level <= 2); // below or at s[2]
            fr1 <= (current_level <= 1); // below or at s[1]
            fr2 <= (current_level == 0); // below s[0]

            // Supplemental flow (rising transition)
            dfr <= (prev_level < current_level) && 
                   (current_level < 3) && 
                   (prev_level != current_level);
        end
    end

endmodule