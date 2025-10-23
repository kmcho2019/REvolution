module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding for water level zones
    localparam ABOVE_S2    = 2'b00;
    localparam BETWEEN_S2_S1 = 2'b01;
    localparam BETWEEN_S1_S0 = 2'b10;
    localparam BELOW_S0   = 2'b11;

    reg [1:0] current_zone, next_zone;
    reg [2:0] stable_sensors;
    reg prev_rising;

    // Hysteresis: Only update zone if sensors are stable for 1 cycle
    always @(posedge clk) begin
        if (reset) begin
            stable_sensors <= 3'b000;
        end else begin
            stable_sensors <= s;
        end
    end

    // Next state logic with hysteresis
    always @(*) begin
        casez (stable_sensors)
            3'b111:  next_zone = ABOVE_S2;
            3'b011:  next_zone = BETWEEN_S2_S1;
            3'b001:  next_zone = BETWEEN_S1_S0;
            3'b000:  next_zone = BELOW_S0;
            default: next_zone = current_zone; // Invalid pattern, hold state
        endcase
    end

    // State transition and rising edge detection
    always @(posedge clk) begin
        if (reset) begin
            current_zone <= BELOW_S0;
            prev_rising <= 1'b0;
        end else begin
            // Detect if we're moving to a higher zone (water level rising)
            prev_rising <= (next_zone < current_zone);
            current_zone <= next_zone;
        end
    end

    // Output logic
    assign fr0 = (current_zone == BETWEEN_S2_S1) || 
                (current_zone == BETWEEN_S1_S0) || 
                (current_zone == BELOW_S0) || reset;

    assign fr1 = (current_zone == BETWEEN_S1_S0) || 
                (current_zone == BELOW_S0) || reset;

    assign fr2 = (current_zone == BELOW_S0) || reset;

    assign dfr = prev_rising && !reset;

endmodule