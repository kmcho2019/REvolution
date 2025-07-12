module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define states encoding water level:
    // 2'b00 - BELOW_S0
    // 2'b01 - BETWEEN_S1_S0
    // 2'b10 - BETWEEN_S2_S1
    // 2'b11 - ABOVE_S2
    localparam BELOW_S0        = 2'b00;
    localparam BETWEEN_S1_S0   = 2'b01;
    localparam BETWEEN_S2_S1   = 2'b10;
    localparam ABOVE_S2        = 2'b11;

    // Function to decode sensors into a water level state
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Sensors arranged vertically s[2] (top), s[1], s[0] (bottom)
            // Determine level as the highest sensor asserted or no sensor
            if (sensors[2]) begin
                decode_level = ABOVE_S2;  // s[2] asserted
            end else if (sensors[1]) begin
                decode_level = BETWEEN_S2_S1;  // s[1] asserted, s[2] not asserted
            end else if (sensors[0]) begin
                decode_level = BETWEEN_S1_S0;  // only s[0] asserted
            end else begin
                decode_level = BELOW_S0;  // no sensors asserted
            end
        end
    endfunction

    reg [1:0] curr_state;
    reg [1:0] prev_state;
    reg [1:0] next_state;

    // Combinational logic: determine next state based on current sensors
    always @(*) begin
        next_state = decode_level(s);
    end

    // Sequential logic: update state and outputs on clock edge
    always @(posedge clk) begin
        if (reset) begin
            // Reset to BELOW_S0 and all outputs asserted
            curr_state <= BELOW_S0;
            prev_state <= BELOW_S0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update previous and current states
            prev_state <= curr_state;
            curr_state <= next_state;

            // Generate nominal flow outputs based on current state
            case (next_state)
                ABOVE_S2: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S2_S1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S1_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Should not occur, default to maximum flow
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve asserted if water level is rising,
            // i.e., current water level state > previous stable state
            if (next_state > prev_state)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule