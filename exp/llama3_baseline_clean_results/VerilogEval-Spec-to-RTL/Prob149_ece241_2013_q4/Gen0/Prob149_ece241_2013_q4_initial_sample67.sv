module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

// Determine the current state based on the sensor inputs
reg [2:0] currentState;
always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the initial state
        currentState <= 3'b000;
    end else begin
        if (s[2]) begin
            // Water level above the highest sensor
            currentState <= 3'b000;
        end else if (s[1] && !s[2]) begin
            // Water level between the upper and middle sensors
            currentState <= 3'b001;
        end else if (s[0] && !s[1] && !s[2]) begin
            // Water level between the middle and lower sensors
            currentState <= 3'b010;
        end else begin
            // Water level below the lowest sensor
            currentState <= 3'b011;
        end
    end
end

// Determine the nominal flow rate based on the current state
always @(posedge clk) begin
    if (reset) begin
        // Reset the flow rates to the maximum
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else begin
        case (currentState)
            3'b000: begin
                // Water level above the highest sensor
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            3'b001: begin
                // Water level between the upper and middle sensors
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b010: begin
                // Water level between the middle and lower sensors
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b011: begin
                // Water level below the lowest sensor
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase
    end
end

// Determine the supplemental flow valve control based on the current and previous states
reg [2:0] previousState;
always @(posedge clk) begin
    if (reset) begin
        // Reset the previous state to the initial state
        previousState <= 3'b000;
    end else begin
        previousState <= currentState;
    end
end

always @(posedge clk) begin
    if (reset) begin
        // Reset the supplemental flow valve to on
        dfr <= 1'b1;
    end else begin
        case (currentState)
            3'b000: begin
                // Water level above the highest sensor
                dfr <= 1'b0;
            end
            3'b001: begin
                // Water level between the upper and middle sensors
                if (previousState < currentState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b010: begin
                // Water level between the middle and lower sensors
                if (previousState < currentState) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b011: begin
                // Water level below the lowest sensor
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule