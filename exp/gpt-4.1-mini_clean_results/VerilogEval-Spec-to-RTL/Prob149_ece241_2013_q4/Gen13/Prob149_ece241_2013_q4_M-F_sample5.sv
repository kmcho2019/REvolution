module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level states encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    // Function to decode sensors to water level state
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // According to spec:
            // Above s[2]: s = 3'b111 or s[2] == 1 -> ABOVE_S2
            // Between s[2] and s[1]: s[2]==0 and s[1]==1 -> BETWEEN_S2_S1
            // Between s[1] and s[0]: s[1]==0 and s[0]==1 -> BETWEEN_S1_S0
            // Below s[0]: s == 3'b000 or no sensors asserted -> BELOW_S0

            if (sensors[2]) begin
                decode_level = ABOVE_S2;
            end else if (sensors[1]) begin
                decode_level = BETWEEN_S2_S1;
            end else if (sensors[0]) begin
                decode_level = BETWEEN_S1_S0;
            end else begin
                decode_level = BELOW_S0;
            end
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            // Reset both levels to BELOW_S0
            current_level <= BELOW_S0;
            prev_level    <= BELOW_S0;
            // At reset all outputs asserted as per spec
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // First, save current_level to prev_level (previous cycle's level)
            prev_level <= current_level;
            // Then decode current sensor input to update current_level
            current_level <= decode_level(s);

            // Update dfr combinationally using registered levels to avoid glitches
            // (will be updated after current_level and prev_level have their new values,
            // so we place dfr update in a separate always @* block)
        end
    end

    // Combinational logic for nominal flow valves based on current_level
    always @(*) begin
        case (current_level)
            BELOW_S0: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            BETWEEN_S1_S0: begin
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            BETWEEN_S2_S1: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
            end
            ABOVE_S2: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
            end
            default: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
        endcase
    end

    // Combinational logic for supplemental flow valve dfr
    // Assert when water level rose from prev_level to current_level
    always @(*) begin
        // Default low if reset active (handled in clocked block)
        if (reset) begin
            dfr = 1'b1;
        end else begin
            dfr = (current_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule