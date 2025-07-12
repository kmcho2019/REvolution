module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define states as one-hot encoding for clarity
    localparam LOW          = 4'b0001; // Below s[0]
    localparam MEDIUM_LOW   = 4'b0010; // Between s[1] and s[0]
    localparam MEDIUM_HIGH  = 4'b0100; // Between s[2] and s[1]
    localparam HIGH         = 4'b1000; // Above s[2]

    reg [3:0] current_state, prev_state;

    // Function to decode sensor inputs into states
    // Sensors:
    // s = 3'b000 => LOW (none asserted)
    // s = 3'b001 => MEDIUM_LOW (s[0] only)
    // s = 3'b011 => MEDIUM_HIGH (s[0], s[1])
    // s = 3'b111 => HIGH (all sensors)
    // Other patterns are mapped conservatively to the nearest lower state:
    // e.g., if s[2] alone asserted, treat as MEDIUM_HIGH or LOW as fallback.
    function [3:0] decode_state;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_state = LOW;
                3'b001: decode_state = MEDIUM_LOW;
                3'b011: decode_state = MEDIUM_HIGH;
                3'b111: decode_state = HIGH;
                default: begin
                    // Assign to closest valid level conservatively
                    if (sensors[0]) // s[0] asserted alone or with others not matching above
                        decode_state = MEDIUM_LOW;
                    else if (sensors[1])
                        decode_state = MEDIUM_HIGH;
                    else if (sensors[2])
                        decode_state = HIGH;
                    else
                        decode_state = LOW;
                end
            endcase
        end
    endfunction

    wire [3:0] next_state = decode_state(s);

    // Determine numeric level index for comparison:
    // LOW=0, MEDIUM_LOW=1, MEDIUM_HIGH=2, HIGH=3
    function [1:0] state_to_level;
        input [3:0] state;
        begin
            case (state)
                LOW:          state_to_level = 2'd0;
                MEDIUM_LOW:   state_to_level = 2'd1;
                MEDIUM_HIGH:  state_to_level = 2'd2;
                HIGH:         state_to_level = 2'd3;
                default:      state_to_level = 2'd0;
            endcase
        end
    endfunction

    // State register update and dfr logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= LOW;
            prev_state <= LOW;
            dfr <= 1'b1; // per spec, on reset all outputs including dfr asserted
        end else begin
            if (next_state != current_state) begin
                prev_state <= current_state;
                current_state <= next_state;
                // Check if level rose: next > current
                if (state_to_level(next_state) > state_to_level(current_state))
                    dfr <= 1'b1;
                else
                    dfr <= 1'b0;
            end else begin
                // No state change, dfr low
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs combinational from current_state:
    // LOW: fr0=1, fr1=1, fr2=1
    // MEDIUM_LOW: fr0=1, fr1=1, fr2=0
    // MEDIUM_HIGH: fr0=1, fr1=0, fr2=0
    // HIGH: fr0=0, fr1=0, fr2=0

    assign fr0 = (current_state == LOW) || (current_state == MEDIUM_LOW) || (current_state == MEDIUM_HIGH);
    assign fr1 = (current_state == LOW) || (current_state == MEDIUM_LOW);
    assign fr2 = (current_state == LOW);

endmodule