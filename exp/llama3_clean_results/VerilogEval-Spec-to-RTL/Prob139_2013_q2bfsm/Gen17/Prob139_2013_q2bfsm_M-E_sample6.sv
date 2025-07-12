module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_counter; // Counts correct 'x' sequence elements
reg [1:0] y_counter; // Counts clocks after 'x' sequence is detected
reg fsm_state; // 0: Reset, 1: Detect x sequence, 2: Wait for y

always @ (posedge clk) begin
    if (!resetn) begin
        fsm_state <= 0;
        x_counter <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (fsm_state)
            0: begin // Reset state
                fsm_state <= 1; // Move to detect x sequence state
                f <= 1; // Set f high for one clock cycle
            end
            1: begin // Detect x sequence
                if (x) begin
                    if (x_counter == 0) begin
                        x_counter <= 1; // First 'x' in sequence
                    end else if (x_counter == 2) begin
                        fsm_state <= 2; // Move to wait for y state
                        x_counter <= 0;
                    end
                end else if (x_counter == 1) begin
                    x_counter <= 2; // Second 'x' in sequence (should be 0)
                end else begin
                    x_counter <= 0; // Reset x_counter
                end
                f <= 0; // Ensure f is low after the first clock cycle
            end
            2: begin // Wait for y
                if (y) begin
                    g <= 1; // Set g high if y occurs
                    fsm_state <= 2; // Stay in this state
                    y_counter <= 0; // Reset y_counter
                end else begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        fsm_state <= 1; // Return to detect x sequence state
                    end
                end
            end
        endcase
    end
end

endmodule