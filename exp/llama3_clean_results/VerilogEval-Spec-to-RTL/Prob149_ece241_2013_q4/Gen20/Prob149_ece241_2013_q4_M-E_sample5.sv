module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state; // Current state of the FSM
reg [2:0] prev_s; // Previous sensor state

// Always block to update state and determine output signals
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state to "below lowest sensor"
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous sensor state
        prev_s <= s;

        // Determine next state based on current state and sensor inputs
        case (state)
            2'b00: // Below lowest sensor
                if (s[0]) begin
                    state <= 2'b01; // Transition to "between lowest and middle sensors"
                end
            2'b01: // Between lowest and middle sensors
                if (s[1]) begin
                    state <= 2'b10; // Transition to "between middle and highest sensors"
                end else if (!s[0]) begin
                    state <= 2'b00; // Transition back to "below lowest sensor"
                end
            2'b10: // Between middle and highest sensors
                if (s[2]) begin
                    state <= 2'b11; // Transition to "above highest sensor"
                end else if (!s[1]) begin
                    state <= 2'b01; // Transition back to "between lowest and middle sensors"
                end
            2'b11: // Above highest sensor
                if (!s[2]) begin
                    state <= 2'b10; // Transition back to "between middle and highest sensors"
                end
        endcase

        // Determine output signals based on current state
        case (state)
            2'b00: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            2'b11: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
        endcase

        // Determine supplemental flow rate signal (dfr)
        if ((s[0] && !prev_s[0]) || (s[1] && !prev_s[1]) || (s[2] && !prev_s[2])) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule