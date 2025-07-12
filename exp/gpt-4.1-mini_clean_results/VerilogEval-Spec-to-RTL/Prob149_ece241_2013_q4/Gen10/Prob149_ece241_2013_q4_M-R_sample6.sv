module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    reg [1:0] prev_level;      // Stored previous level state
    reg [1:0] current_level;   // Current decoded level state

    // Decode sensors to water level (deterministic for all 3-bit inputs)
    // Priority from highest water level down to lowest:
    // If s == 111          : ABOVE_S2
    // Else if s[2]==0 && s[1]==1 && s[0]==1 : BETWEEN_S2_S1 (011)
    // Else if s[0]==1 && (s[1]==0)           : BETWEEN_S1_S0 (001)
    // Else if s == 000                      : BELOW_S0
    // For other cases:
    // If s[0]==1 -> BETWEEN_S1_S0
    // Else if s[1]==1 -> BETWEEN_S2_S1
    // Else if s[2]==1 -> ABOVE_S2
    // Else BELOW_S0
    // This ensures all input patterns map to a level.
    wire [1:0] decoded_level;
    assign decoded_level =
        (s == 3'b111) ? ABOVE_S2 :
        (s == 3'b011) ? BETWEEN_S2_S1 :
        (s == 3'b001) ? BETWEEN_S1_S0 :
        (s == 3'b000) ? BELOW_S0 :
        (s[0] == 1'b1) ? BETWEEN_S1_S0 :
        (s[1] == 1'b1) ? BETWEEN_S2_S1 :
        (s[2] == 1'b1) ? ABOVE_S2 :
        BELOW_S0;

    // FSM sequential logic: store previous level and current level,
    // and update dfr if level rising
    always @(posedge clk) begin
        if (reset) begin
            prev_level   <= BELOW_S0;    // Reset to lowest level state
            current_level <= BELOW_S0;
            dfr          <= 1'b1;        // dfr asserted on reset per spec
        end else begin
            current_level <= decoded_level;

            // dfr set if water level rose compared to previous
            dfr <= (decoded_level > prev_level);

            // Update prev_level for next cycle
            prev_level <= decoded_level;
        end
    end

    // Combinational outputs fr2, fr1, fr0 based on current_level state
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
            default: begin // Defensive fallback
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
        endcase
    end

endmodule