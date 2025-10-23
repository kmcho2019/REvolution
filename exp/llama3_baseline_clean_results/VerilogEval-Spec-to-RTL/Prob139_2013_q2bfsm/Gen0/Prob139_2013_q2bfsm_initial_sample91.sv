module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // State machine states
reg [1:0] x_sequence; // Track x input sequence
reg y_detected; // Flag to indicate y=1 detected
reg [1:0] y_timer; // Timer for checking y within two cycles

always @(posedge clk) begin
    if (!resetn) begin // Reset condition
        state <= 2'b00; // State A
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_detected <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (resetn) begin
                    state <= 2'b01; // Transition to State B
                    f <= 1; // Set f=1 for one cycle
                end
            end
            2'b01: begin // State B
                state <= 2'b10; // Move to State C
                f <= 0; // Reset f
            end
            2'b10: begin // State C
                if (x_sequence == 2'b101) begin
                    state <= 2'b11; // Transition to State D
                    g <= 1; // Set g=1
                    x_sequence <= 0; // Reset sequence
                    y_timer <= 0; // Reset y_timer
                end else begin
                    x_sequence <= {x_sequence[0], x}; // Update sequence
                end
            end
            2'b11: begin // State D
                if (!y_detected) begin
                    if (y) begin
                        y_detected <= 1; // y=1 detected
                    end else begin
                        y_timer <= y_timer + 1; // Increment timer
                        if (y_timer == 2) begin
                            g <= 0; // If y not detected within two cycles, set g=0
                            y_detected <= 1; // Prevent further checks
                        end
                    end
                end
            end
            default: state <= 2'b00; // Default to State A
        endcase
    end
end

endmodule