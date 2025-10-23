module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states (2 bits sufficient)
    typedef enum reg [1:0] {
        BELOW = 2'b00,  // No sensors asserted
        LOW   = 2'b01,  // Only s[0] asserted
        MID   = 2'b10,  // s[0] and s[1] asserted
        HIGH  = 2'b11   // s[0], s[1], s[2] asserted
    } state_t;

    reg [1:0] state, prev_state;

    // Decode sensors to state
    function state_t decode_state(input [2:0] sensors);
        begin
            case (sensors)
                3'b000: decode_state = BELOW;
                3'b001: decode_state = LOW;
                3'b011: decode_state = MID;
                3'b111: decode_state = HIGH;
                default: decode_state = state; // On invalid sensor pattern, stay in previous state
            endcase
        end
    endfunction

    // State transition and previous state capture
    always @(posedge clk) begin
        if (reset) begin
            state      <= BELOW;
            prev_state <= BELOW;
        end else begin
            prev_state <= state;
            state      <= decode_state(s);
        end
    end

    // Supplemental flow valve dfr: asserted if level rises compared to previous state
    assign dfr = (state > prev_state);

    // Nominal flow rate signals combinationally from current state
    // Per table:
    // HIGH   : no nominal flow valves (fr2,fr1,fr0 = 000)
    // MID    : fr0 only (001)
    // LOW    : fr1 and fr0 (011)
    // BELOW  : fr2, fr1, fr0 all asserted (111)
    assign {fr2, fr1, fr0} =
        (state == HIGH) ? 3'b000 :
        (state == MID)  ? 3'b001 :
        (state == LOW)  ? 3'b011 :
                         3'b111; // BELOW

endmodule