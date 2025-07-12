module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // One-hot states for water level
    localparam LOW          = 4'b0001; // Below s[0]
    localparam MEDIUM_LOW   = 4'b0010; // Between s[1] and s[0]
    localparam MEDIUM_HIGH  = 4'b0100; // Between s[2] and s[1]
    localparam HIGH         = 4'b1000; // Above s[2]

    reg [3:0] current_state, prev_state;

    // Decode sensors into states
    // Valid sensor patterns per problem: 000=LOW, 001=MEDIUM_LOW, 011=MEDIUM_HIGH, 111=HIGH
    // Others map conservatively downwards to closest valid state
    function [3:0] decode_state;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_state = LOW;
                3'b001: decode_state = MEDIUM_LOW;
                3'b011: decode_state = MEDIUM_HIGH;
                3'b111: decode_state = HIGH;
                default: begin
                    // If s[0] asserted, treat as MEDIUM_LOW (between s[1] and s[0])
                    if (sensors[0])
                        decode_state = MEDIUM_LOW;
                    // Else if s[1] asserted, MEDIUM_HIGH (between s[2] and s[1])
                    else if (sensors[1])
                        decode_state = MEDIUM_HIGH;
                    // Else if s[2] asserted, HIGH (above s[2])
                    else if (sensors[2])
                        decode_state = HIGH;
                    else
                        decode_state = LOW;
                end
            endcase
        end
    endfunction

    // Numeric water levels for comparison: LOW=0 ... HIGH=3
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

    wire [3:0] next_state = decode_state(s);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to LOW state with all outputs asserted as per spec
            current_state <= LOW;
            prev_state <= LOW;
            dfr <= 1'b1;
        end else begin
            if (next_state != current_state) begin
                // On level change, save old state before updating current
                prev_state <= current_state;
                current_state <= next_state;

                // Compare new level with old level (prev_state)
                if (state_to_level(next_state) > state_to_level(current_state))
                    dfr <= 1'b1;
                else
                    dfr <= 1'b0;
            end else begin
                // No state change means no rise, dfr low
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs combinational from current_state
    assign fr0 = (current_state == LOW) || (current_state == MEDIUM_LOW) || (current_state == MEDIUM_HIGH);
    assign fr1 = (current_state == LOW) || (current_state == MEDIUM_LOW);
    assign fr2 = (current_state == LOW);

endmodule