module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states for water levels
    localparam BELOW_S0  = 2'b00;  // No sensors active
    localparam BTWN_S0S1 = 2'b01;  // Only s[0] active
    localparam BTWN_S1S2 = 2'b10;  // s[0] and s[1] active
    localparam ABOVE_S2  = 2'b11;  // All sensors active

    reg [1:0] current_state, next_state;
    reg [2:0] prev_sensors;

    // State transition logic
    always @(*) begin
        case (s)
            3'b000: next_state = BELOW_S0;   // Below s[0]
            3'b001: next_state = BTWN_S0S1;  // Between s[0]-s[1]
            3'b011: next_state = BTWN_S1S2;  // Between s[1]-s[2]
            3'b111: next_state = ABOVE_S2;   // Above s[2]
            default: next_state = current_state; // Handle invalid patterns
        endcase
    end

    // State register and sensor history
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_S0;
            prev_sensors <= 3'b000;
        end else begin
            prev_sensors <= s;
            current_state <= next_state;
        end
    end

    // Output logic - fr2, fr1, fr0 based on current state
    assign fr0 = (current_state != ABOVE_S2);
    assign fr1 = (current_state == BELOW_S0) || (current_state == BTWN_S0S1);
    assign fr2 = (current_state == BELOW_S0);

    // Detect if water level is rising (any sensor newly activated)
    assign dfr = ((s[0] & ~prev_sensors[0]) || 
                 (s[1] & ~prev_sensors[1]) || 
                 (s[2] & ~prev_sensors[2]));

endmodule