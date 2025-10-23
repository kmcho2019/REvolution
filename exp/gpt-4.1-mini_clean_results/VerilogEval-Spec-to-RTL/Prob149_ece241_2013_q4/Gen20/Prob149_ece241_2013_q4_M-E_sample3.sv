module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define states encoding water level: 0 to 3
    // state encoding matches:
    // 0 = below s[0]
    // 1 = between s[1] and s[0]
    // 2 = between s[2] and s[1]
    // 3 = above s[2]
    localparam [1:0]
        LEVEL_0 = 2'd0,
        LEVEL_1 = 2'd1,
        LEVEL_2 = 2'd2,
        LEVEL_3 = 2'd3;

    // Decode current water level state from sensors
    function [1:0] decode_state(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_state = LEVEL_3;
                3'b011: decode_state = LEVEL_2;
                3'b001: decode_state = LEVEL_1;
                default: decode_state = LEVEL_0;
            endcase
        end
    endfunction

    reg [1:0] state, prev_state;
    wire [1:0] next_state = decode_state(s);

    // Update state machine, track previous state for dfr decision
    always @(posedge clk) begin
        if (reset) begin
            state <= LEVEL_0;
            prev_state <= LEVEL_0;
            dfr <= 1'b1; // all valves open on reset
        end else begin
            prev_state <= state;
            state <= next_state;
            // Supplemental flow valve dfr asserted if rising water level
            dfr <= (next_state > state);
        end
    end

    // Nominal flow valves output combinationally according to current state
    // LEVEL_3 (3): fr0=0, fr1=0, fr2=0 (flow rate zero)
    // LEVEL_2 (2): fr0=1, fr1=0, fr2=0
    // LEVEL_1 (1): fr0=1, fr1=1, fr2=0
    // LEVEL_0 (0): fr0=1, fr1=1, fr2=1
    assign fr0 = (state != LEVEL_3);
    assign fr1 = (state <= LEVEL_1);
    assign fr2 = (state == LEVEL_0);

endmodule