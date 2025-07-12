module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State machine states
enum logic [1:0] {
    IDLE,
    SET_F,
    WAIT_Y,
    MONITOR_X
} state;

// Sequence detector for 'x'
reg [1:0] x_seq;

// Counter for monitoring 'y'
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        // Reset all states and outputs
        state <= IDLE;
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Set 'f' to 1 for one clock cycle after reset is de-asserted
                f <= 1;
                state <= SET_F;
            end
            SET_F: begin
                f <= 0;
                state <= MONITOR_X;
            end
            MONITOR_X: begin
                // Monitor 'x' for the sequence 1, 0, 1
                case (x_seq)
                    0: if (x) x_seq <= 1;
                    1: if (!x) x_seq <= 2; else x_seq <= 1;
                    2: if (x) begin
                        x_seq <= 0;
                        state <= WAIT_Y;
                    end else x_seq <= 0;
                endcase
            end
            WAIT_Y: begin
                // Monitor 'y' and set 'g' accordingly
                if (y) begin
                    g <= 1;
                    state <= IDLE; // Stay in IDLE once 'g' is set
                end else if (y_count < 2) begin
                    y_count <= y_count + 1;
                end else begin
                    g <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule