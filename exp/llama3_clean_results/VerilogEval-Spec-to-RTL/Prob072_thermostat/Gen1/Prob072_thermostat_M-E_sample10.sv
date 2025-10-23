module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    reg [1:0] state;
    initial state = 2'b00; // Initial state: idle

    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        case (state)
            2'b00: // Idle state
                begin
                    if (mode) begin // Heating mode
                        if (too_cold) begin
                            state <= 2'b01; // Heating state
                        end else if (fan_on) begin
                            state <= 2'b10; // Fan only state
                        end
                    end else begin // Cooling mode
                        if (too_hot) begin
                            state <= 2'b11; // Cooling state
                        end else if (fan_on) begin
                            state <= 2'b10; // Fan only state
                        end
                    end
                end
            2'b01: // Heating state
                begin
                    if (!too_cold) begin
                        state <= 2'b00; // Back to idle state
                    end
                end
            2'b10: // Fan only state
                begin
                    if (!fan_on) begin
                        state <= 2'b00; // Back to idle state
                    end
                end
            2'b11: // Cooling state
                begin
                    if (!too_hot) begin
                        state <= 2'b00; // Back to idle state
                    end
                end
        endcase
    end

    always @(posedge state) begin
        case (state)
            2'b00: // Idle state
                begin
                    heater <= 1'b0;
                    aircon <= 1'b0;
                    fan <= 1'b0;
                end
            2'b01: // Heating state
                begin
                    heater <= 1'b1;
                    aircon <= 1'b0;
                    fan <= 1'b1;
                end
            2'b10: // Fan only state
                begin
                    heater <= 1'b0;
                    aircon <= 1'b0;
                    fan <= 1'b1;
                end
            2'b11: // Cooling state
                begin
                    heater <= 1'b0;
                    aircon <= 1'b1;
                    fan <= 1'b1;
                end
        endcase
    end

endmodule