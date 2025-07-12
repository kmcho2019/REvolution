module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // only s[0] asserted
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE_S2      = 2'd3; // all sensors asserted

    // Combinational decoding of current stable level from sensor input
    reg [1:0] stable_level;
    always @(*) begin
        case (s)
            3'b000: stable_level = BELOW_S0;
            3'b001: stable_level = BETWEEN_S1_S0;   // only s[0]
            3'b011: stable_level = BETWEEN_S2_S1;   // s[0], s[1]
            3'b111: stable_level = ABOVE_S2;        // s[0], s[1], s[2]
            default: stable_level = BELOW_S0;       // conservative default
        endcase
    end

    reg [1:0] prev_level;

    // On synchronous clock, update prev_level and dfr based on level changes
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= BELOW_S0;
            dfr        <= 1'b1; // as if water low for long time
        end else begin
            // dfr = 1 if level rose from prev_level to current stable_level
            dfr <= (stable_level > prev_level) ? 1'b1 : 1'b0;
            prev_level <= stable_level;
        end
    end

    // Nominal flow outputs combinationally derived from stable_level
    // ABOVE_S2: all valves off
    // BETWEEN_S2_S1: fr0 only
    // BETWEEN_S1_S0: fr0 and fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (stable_level != ABOVE_S2);
    assign fr1 = (stable_level == BETWEEN_S1_S0) || (stable_level == BELOW_S0);
    assign fr2 = (stable_level == BELOW_S0);

endmodule