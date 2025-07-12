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

    // Sequential logic: update state registers
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= BELOW_S0;
            prev_state <= BELOW_S0;
        end else begin
            prev_state <= curr_state;
            curr_state <= next_state;
        end
    end

    // Combinational logic to determine next state based on sensors
    always @(*) begin
        next_state = decode_level(s);
    end

    // Combinational output logic
    always @(*) begin
        // Nominal flow valves based on current water level state
        case (curr_state)
            ABOVE_S2: begin
                fr0 = 1'b0;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            BETWEEN_S2_S1: begin
                fr0 = 1'b1;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            BETWEEN_S1_S0: begin
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b0;
            end
            BELOW_S0: begin
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
            default: begin
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
        endcase

        // Supplemental flow valve dfr: asserted if water level is rising
        // Rising means next_state > curr_state
        dfr = (next_state > curr_state) ? 1'b1 : 1'b0;
    end

    // Override outputs on reset to match initial state with all valves asserted
    always @(posedge clk) begin
        if (reset) begin
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            fr0 <= fr0;
            fr1 <= fr1;
            fr2 <= fr2;
            dfr <= dfr;
        end
    end

endmodule