module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states (2 bits)
    typedef enum reg [1:0] {
        BELOW = 2'b00,  // No sensors asserted
        LOW   = 2'b01,  // Only s[0] asserted
        MID   = 2'b10,  // s[0] and s[1] asserted
        HIGH  = 2'b11   // s[0], s[1], s[2] asserted
    } state_t;

    reg [1:0] state, prev_state;

    // Decode sensors to state: exact valid patterns only
    function state_t decode_state(input [2:0] sensors);
        begin
            case (sensors)
                3'b000: decode_state = BELOW;
                3'b001: decode_state = LOW;
                3'b011: decode_state = MID;
                3'b111: decode_state = HIGH;
                default: decode_state = BELOW; // Other patterns treated as BELOW for stability
            endcase
        end
    endfunction

    // Function to convert state_t to numeric water level (0 to 3)
    function [1:0] state_level(input state_t st);
        begin
            case (st)
                BELOW: state_level = 2'd0;
                LOW:   state_level = 2'd1;
                MID:   state_level = 2'd2;
                HIGH:  state_level = 2'd3;
                default: state_level = 2'd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state      <= BELOW;
            prev_state <= BELOW;
        end else begin
            prev_state <= state;
            state      <= decode_state(s);
        end
    end

    // Compare numeric levels for dfr: assert if water level rose
    wire [1:0] curr_level = state_level(state);
    wire [1:0] prev_level = state_level(prev_state);

    assign dfr = (curr_level > prev_level);

    // Nominal flow rate outputs per spec
    // HIGH   : no nominal valves (000)
    // MID    : fr0 only (001)
    // LOW    : fr1 and fr0 (011)
    // BELOW  : fr2, fr1, fr0 all asserted (111)
    assign {fr2, fr1, fr0} =
        (state == HIGH) ? 3'b000 :
        (state == MID)  ? 3'b001 :
        (state == LOW)  ? 3'b011 :
                         3'b111; // BELOW

endmodule