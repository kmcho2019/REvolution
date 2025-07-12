module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definitions
enum logic [1:0] {RESET, SET_F, WAIT_X, WAIT_Y} state, next_state;

// Signals for sequence detection and timeout
reg [1:0] x_seq; // Tracks sequence of x
reg [1:0] y_timeout; // Counts clocks after x sequence is detected

// Output assignments
assign f = (state == SET_F);

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_seq <= 0;
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
                if (x) begin
                    x_seq <= {x_seq[0], 1'b1};
                end else begin
                    x_seq <= {x_seq[0], 1'b0};
                end
                if (x_seq == 2'b01 && x) begin // Detect '1, 0, 1' sequence
                    state <= WAIT_Y;
                    g <= 1;
                    y_timeout <= 0;
                end else if (x_seq != 0 && x_seq != 2'b01) begin
                    x_seq <= 0; // Reset x_seq if not the desired sequence
                end
            end
            WAIT_Y: begin
                if (y) begin
                    y_timeout <= 0; // Reset y_timeout
                    state <= WAIT_Y; // Stay in WAIT_Y state if y is high
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        state <= WAIT_X; // Return to WAIT_X state
                    end
                end
            end
        endcase
    end
end

endmodule