module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encoded water levels
    localparam BELOW_S0 = 2'b00; // No sensors
    localparam BTWN_S0_S1 = 2'b01; // s[0] only
    localparam BTWN_S1_S2 = 2'b10; // s[1:0]
    localparam ABOVE_S2 = 2'b11; // s[2:0]

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Synchronous level detection
    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            prev_level <= current_level;
            case (s)
                3'b000: current_level <= BELOW_S0;
                3'b001: current_level <= BTWN_S0_S1;
                3'b011: current_level <= BTWN_S1_S2;
                3'b111: current_level <= ABOVE_S2;
                default: current_level <= current_level; // Maintain on invalid
            endcase
        end
    end

    // Output logic - all synchronous
    always @(posedge clk) begin
        if (reset) begin
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Base flow rates
            fr0 <= (current_level != ABOVE_S2);
            fr1 <= (current_level == BELOW_S0) || (current_level == BTWN_S0_S1);
            fr2 <= (current_level == BELOW_S0);
            
            // Supplemental flow
            dfr <= (current_level > prev_level) && (current_level != ABOVE_S2);
        end
    end

endmodule