module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Enumerate water level states for clarity
    typedef enum logic [1:0] {
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3
    } water_level_t;

    water_level_t current_level;
    water_level_t previous_level;

    // Decode sensor inputs to water level state
    // According to problem:
    // Above s[2]: s=111
    // Between s[2] and s[1]: s=011 (s[2]=0, s[1]=1, s[0]=1)
    // Between s[1] and s[0]: s=001 (s[2]=0, s[1]=0, s[0]=1)
    // Below s[0]: s=000
    // Other combinations (e.g. 010, 100, 101, 110) not specified - treat as BELOW_S0 for safety
    always @(*) begin
        case (s)
            3'b111: current_level = ABOVE_S2;
            3'b011: current_level = BETWEEN_S2_S1;
            3'b001: current_level = BETWEEN_S1_S0;
            3'b000: current_level = BELOW_S0;
            default: current_level = BELOW_S0;
        endcase
    end

    // Synchronous FSM and dfr update
    always @(posedge clk) begin
        if (reset) begin
            previous_level <= BELOW_S0;
            dfr <= 1'b1; // Supplemental valve opened on reset (as if low water for long time)
        end else begin
            // dfr is asserted if water level rose compared to previous_level
            dfr <= (current_level > previous_level);
            previous_level <= current_level;
        end
    end

    // Nominal flow rate outputs combinational from current water level state
    // According to problem:
    // Above s[2] (state=3): no fr outputs
    // Between s[2] and s[1] (2): fr0
    // Between s[1] and s[0] (1): fr0, fr1
    // Below s[0] (0): fr0, fr1, fr2
    assign fr2 = (current_level == BELOW_S0);
    assign fr1 = (current_level == BELOW_S0) || (current_level == BETWEEN_S1_S0);
    assign fr0 = (current_level != ABOVE_S2);

endmodule