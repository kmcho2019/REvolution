module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level states
    typedef enum reg [1:0] {
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3
    } water_level_t;

    water_level_t curr_level, prev_level;

    // Function to decode sensor input into water level state
    function water_level_t decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                default: decode_level = BELOW_S0; // Treat unspecified as BELOW_S0
            endcase
        end
    endfunction

    // Sequential logic: update current and previous level and dfr output
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            dfr        <= 1'b1; // All outputs asserted on reset, including dfr
        end else begin
            prev_level <= curr_level;
            curr_level <= decode_level(s);
            dfr        <= (decode_level(s) > curr_level) ? 1'b1 : 1'b0;
        end
    end

    // Nominal flow outputs combinational from curr_level
    assign fr2 = (curr_level == BELOW_S0);
    assign fr1 = (curr_level == BELOW_S0) || (curr_level == BETWEEN_S1_S0);
    assign fr0 = (curr_level != ABOVE_S2);

endmodule