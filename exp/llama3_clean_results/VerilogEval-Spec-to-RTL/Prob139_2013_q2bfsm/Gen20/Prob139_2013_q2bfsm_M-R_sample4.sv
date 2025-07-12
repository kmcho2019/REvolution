module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State definitions
enum logic [1:0] {RESET, SET_F, WAIT_X, WAIT_Y_PERM} state, next_state;

// Signals for sequence detection and timeout
reg [1:0] x_prev; // Tracks previous two values of x
reg [1:0] y_timeout; // Counts clocks after x sequence is detected

// Output assignments
assign f = (state == SET_F);

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_prev <= 0;
        y_timeout <= 0;
        g <= 0;
    end else begin
        case (state)
            RESET: begin
                state <= SET_F;
            end
            SET_F: begin
                state <= WAIT_X;
            end
            WAIT_X: begin
                x_prev <= {x, x_prev[0]}; // Update x_prev with current x and previous x
                if (x_prev == 2'b101) begin // Detect '1, 0, 1' sequence
                    state <= WAIT_Y;
                    g <= 1;
                    y_timeout <= 0;
                end
            end
            WAIT_Y: begin
                if (y) begin
                    state <= WAIT_Y_PERM; // Move to permanent WAIT_Y state
                end else if (y_timeout == 1) begin
                    g <= 0; // Set g low if y doesn't occur within 2 clocks
                    state <= WAIT_X; // Return to WAIT_X state
                end else begin
                    y_timeout <= y_timeout + 1;
                end
            end
            WAIT_Y_PERM: begin
                // Stay in permanent WAIT_Y state
            end
        endcase
    end
end

endmodule