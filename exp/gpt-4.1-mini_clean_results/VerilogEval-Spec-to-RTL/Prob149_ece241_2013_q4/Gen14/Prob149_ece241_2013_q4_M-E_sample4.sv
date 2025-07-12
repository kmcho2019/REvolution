module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water levels as states
    typedef enum logic [1:0] {
        BELOW_S0       = 2'd0,
        BETWEEN_S1_S0  = 2'd1,
        BETWEEN_S2_S1  = 2'd2,
        ABOVE_S2       = 2'd3
    } water_level_t;

    water_level_t current_level, next_level;

    // Function to decode sensors to water level state
    function water_level_t decode_level(input [2:0] sensors);
        begin
            if (sensors == 3'b111)        decode_level = ABOVE_S2;         // all sensors asserted
            else if (sensors == 3'b011)   decode_level = BETWEEN_S2_S1;   // top sensor low
            else if (sensors == 3'b001)   decode_level = BETWEEN_S1_S0;   // only bottom sensor asserted
            else if (sensors == 3'b000)   decode_level = BELOW_S0;         // no sensors asserted
            else begin
                // For any other combination, prioritize highest sensor asserted
                if (sensors[2])            decode_level = ABOVE_S2;
                else if (sensors[1])       decode_level = BETWEEN_S2_S1;
                else if (sensors[0])       decode_level = BETWEEN_S1_S0;
                else                      decode_level = BELOW_S0;
            end
        end
    endfunction

    // FSM: update state on clock, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;  // reset to lowest level state
            dfr <= 1'b1;                // all outputs asserted on reset, so dfr=1
        end else begin
            next_level = decode_level(s);

            // dfr is asserted if water level increases from current_level to next_level
            dfr <= (next_level > current_level);

            // State update: transition to next water level
            current_level <= next_level;
        end
    end

    // Nominal flow rate outputs combinationally derived from current_level state
    assign {fr2, fr1, fr0} =
        (current_level == BELOW_S0)       ? 3'b111 :
        (current_level == BETWEEN_S1_S0)  ? 3'b011 :
        (current_level == BETWEEN_S2_S1)  ? 3'b001 :
        (current_level == ABOVE_S2)        ? 3'b000 :
        3'b111; // default safe output

endmodule