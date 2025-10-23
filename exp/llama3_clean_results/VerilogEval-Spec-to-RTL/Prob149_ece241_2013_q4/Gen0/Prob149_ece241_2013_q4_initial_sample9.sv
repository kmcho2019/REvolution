module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state; // FSM state: 0 - BELOW_S0, 1 - BETWEEN_S1_S0, 2 - BETWEEN_S2_S1, 3 - ABOVE_S2
reg [1:0] prev_state; // previous FSM state

// Define the states
parameter BELOW_S0 = 2'b00;
parameter BETWEEN_S1_S0 = 2'b01;
parameter BETWEEN_S2_S1 = 2'b10;
parameter ABOVE_S2 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        state <= BELOW_S0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous state
        prev_state <= state;

        // Determine new state based on input sensors
        if (s[2]) begin
            // Water level is above the highest sensor
            state <= ABOVE_S2;
        end else if (s[1] && !s[2]) begin
            // Water level is between the upper and middle sensors
            state <= BETWEEN_S2_S1;
        end else if (s[0] && !s[1] && !s[2]) begin
            // Water level is between the middle and lower sensors
            state <= BETWEEN_S1_S0;
        end else begin
            // Water level is below the lowest sensor
            state <= BELOW_S0;
        end

        // Determine outputs based on current state and previous state
        case (state)
            BELOW_S0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == BETWEEN_S1_S0 || prev_state == BETWEEN_S2_S1 || prev_state == ABOVE_S2) begin
                    dfr <= 1'b1; // Open supplemental flow valve if water level was previously higher
                end else begin
                    dfr <= 1'b1; // Always open supplemental flow valve when water level is below the lowest sensor
                end
            end
            BETWEEN_S1_S0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == BELOW_S0) begin
                    dfr <= 1'b1; // Open supplemental flow valve if water level was previously lower
                end else begin
                    dfr <= 1'b0;
                end
            end
            BETWEEN_S2_S1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_state == BETWEEN_S1_S0) begin
                    dfr <= 1'b1; // Open supplemental flow valve if water level was previously lower
                end else begin
                    dfr <= 1'b0;
                end
            end
            ABOVE_S2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule