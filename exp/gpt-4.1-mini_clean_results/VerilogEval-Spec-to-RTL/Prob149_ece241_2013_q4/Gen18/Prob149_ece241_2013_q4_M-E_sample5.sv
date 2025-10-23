module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define distinct water level states
    typedef enum logic [1:0] {
        BELOW_S0      = 2'b00,
        BETWEEN_S1_S0 = 2'b01,
        BETWEEN_S2_S1 = 2'b10,
        ABOVE_S2      = 2'b11
    } level_t;

    level_t curr_state, prev_state;

    // Combinational function to decode sensors into water level state
    function level_t decode_level(input [2:0] sensors);
        begin
            if (sensors[2] == 1'b1 && sensors[1] == 1'b1 && sensors[0] == 1'b1)
                decode_level = ABOVE_S2;
            else if (sensors[1] == 1'b1 && sensors[0] == 1'b1)
                decode_level = BETWEEN_S2_S1;
            else if (sensors[0] == 1'b1)
                decode_level = BETWEEN_S1_S0;
            else
                decode_level = BELOW_S0;
        end
    endfunction

    // Function to give order rank of level for comparison
    function automatic int level_rank(input level_t lvl);
        begin
            case (lvl)
                BELOW_S0:      level_rank = 0;
                BETWEEN_S1_S0: level_rank = 1;
                BETWEEN_S2_S1: level_rank = 2;
                ABOVE_S2:      level_rank = 3;
                default:       level_rank = -1;
            endcase
        end
    endfunction

    // Sequential logic to update states synchronously
    always @(posedge clk) begin
        if (reset) begin
            // Reset both states to lowest level => all flow valves open
            curr_state <= BELOW_S0;
            prev_state <= BELOW_S0;
        end else begin
            prev_state <= curr_state;
            curr_state <= decode_level(s);
        end
    end

    // Determine if water level has risen since last cycle
    assign dfr = (level_rank(curr_state) > level_rank(prev_state));

    // Nominal flow valve outputs per problem specification:
    // Above s2: no nominal valves open
    // Between s2 and s1: fr0 only
    // Between s1 and s0: fr0 and fr1
    // Below s0: fr0, fr1, fr2
    assign fr0 = (curr_state != ABOVE_S2);
    assign fr1 = (curr_state == BETWEEN_S1_S0) || (curr_state == BELOW_S0);
    assign fr2 = (curr_state == BELOW_S0);

endmodule