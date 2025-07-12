module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the main states
typedef enum logic [1:0] {
    IDLE,
    SET_F,
    MONITOR_X,
    MONITOR_Y
} state_t;

state_t state, next_state;

// Registers for state and next state
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        // Reset f after initialization
        if (state == SET_F) begin
            f <= 1;
        end else begin
            f <= 0;
        end
        // Update g based on state
        case (state)
            MONITOR_Y: g <= 1;
            default: g <= 0;
        endcase
    end
end

// Combinational logic to determine next state
logic [1:0] x_seq;
always @(posedge clk) begin
    if (!resetn) begin
        x_seq <= 0;
    end else if (state == MONITOR_X) begin
        if (x) begin
            x_seq <= x_seq + 1;
        end else begin
            x_seq <= 0;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = (resetn) ? SET_F : IDLE;
        SET_F: next_state = MONITOR_X;
        MONITOR_X: next_state = (x_seq == 3) ? MONITOR_Y : MONITOR_X;
        MONITOR_Y: next_state = (y) ? MONITOR_Y : (x_seq == 3) ? MONITOR_Y : MONITOR_X;
    endcase
end

endmodule