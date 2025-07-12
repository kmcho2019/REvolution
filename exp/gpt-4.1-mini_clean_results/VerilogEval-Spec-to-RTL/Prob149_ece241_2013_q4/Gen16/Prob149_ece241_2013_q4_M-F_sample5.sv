module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding (2 bits)
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1]
    localparam ABOVE_S2      = 2'd3; // s[0], s[1], s[2]

    // Decode sensor inputs into water levels:
    // Map unrecognized patterns to closest valid level to avoid glitches
    function [1:0] decode_sensors;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_sensors = BELOW_S0;
                3'b001: decode_sensors = BETWEEN_S1_S0;
                3'b011: decode_sensors = BETWEEN_S2_S1;
                3'b111: decode_sensors = ABOVE_S2;
                // Map partial sensor assertions conservatively:
                3'b010: decode_sensors = BETWEEN_S1_S0;   // s[1] only ~ treat as between s1,s0
                3'b100: decode_sensors = BELOW_S0;        // s[2] only ~ treat as below s0 (sensor fault)
                3'b101: decode_sensors = BETWEEN_S1_S0;   // s[0] and s[2] non-adjacent ~ treat as between s1,s0
                3'b110: decode_sensors = BETWEEN_S2_S1;   // s[1] and s[2] ~ treat as between s2,s1
                default: decode_sensors = BELOW_S0;        // fallback
            endcase
        end
    endfunction

    wire [1:0] new_level = decode_sensors(s);

    reg [1:0] stable_level;
    reg [1:0] prev_level;

    // Flag indicating request to generate dfr pulse on next cycle
    reg dfr_pulse_req;

    always @(posedge clk) begin
        if (reset) begin
            stable_level <= BELOW_S0;
            prev_level   <= BELOW_S0;
            dfr          <= 1'b1;  // all valves open on reset
            dfr_pulse_req <= 1'b0;
        end else begin
            // Detect and update level changes
            if (new_level != stable_level) begin
                prev_level   <= stable_level;
                stable_level <= new_level;

                // If upward transition, request dfr pulse next cycle
                if (new_level > stable_level) begin
                    dfr_pulse_req <= 1'b1;
                end else begin
                    dfr_pulse_req <= 1'b0;
                end
            end else begin
                dfr_pulse_req <= 1'b0;
            end

            // Generate dfr pulse for exactly one cycle when requested
            if (dfr_pulse_req) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs depend on stable_level:
    // ABOVE_S2: no valves open
    // BETWEEN_S2_S1: fr0 only
    // BETWEEN_S1_S0: fr0 and fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (stable_level != ABOVE_S2);
    assign fr1 = (stable_level == BETWEEN_S1_S0) || (stable_level == BELOW_S0);
    assign fr2 = (stable_level == BELOW_S0);

endmodule