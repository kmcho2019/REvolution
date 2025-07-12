module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // State register
reg [1:0] counter; // Counter for states C and D
reg [1:0] x_prev; // Previous values of x

always @(posedge clk) begin
    if (~resetn) begin // Reset
        state <= 0; // State A
        f <= 0;
        g <= 0;
        counter <= 0;
        x_prev <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // Transition to State B
                end
            end
            1: begin // State B
                f <= 1; // Set f to 1
                state <= 2; // Transition to State C
            end
            2: begin // State C
                {x_prev[1], x_prev[0]} <= {x_prev[0], x}; // Update previous values of x
                if (x_prev[1] == 1 && x_prev[0] == 0 && x == 1) begin // Check for sequence 1, 0, 1
                    state <= 3; // Transition to State D
                end
            end
            3: begin // State D
                g <= 1; // Set g to 1
                if (y) begin // Check for y = 1
                    state <= 4; // Transition to State E
                end else begin
                    counter <= counter + 1; // Increment counter
                    if (counter == 2) begin // If y is not 1 within two clock cycles
                        state <= 5; // Transition to State F
                    end
                end
            end
            4: begin // State E
                g <= 1; // Maintain g = 1
            end
            5: begin // State F
                g <= 0; // Maintain g = 0
            end
            default: begin
                state <= 0; // Default state
            end
        endcase
        if (state != 1) begin // Reset f
            f <= 0;
        end
        if (state != 3 && state != 4) begin // Reset counter
            counter <= 0;
        end
    end
end

endmodule