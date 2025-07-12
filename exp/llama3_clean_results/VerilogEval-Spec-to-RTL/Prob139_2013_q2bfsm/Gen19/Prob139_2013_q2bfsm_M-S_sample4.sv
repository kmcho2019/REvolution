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
        if (state == IDLE && resetn) begin
            f <= 1;
        end else begin
            f <= 0;
        end
    end
end

// Combinational logic to determine next state
reg [1:0] x_seq;
reg x_prev;
always @(posedge clk) begin
    if (!resetn) begin
        x_seq <= 0;
        x_prev <= 0;
    end else if (state == MONITOR_X) begin
        if (x) begin
            if (x_prev == 0 && x_seq == 1) begin
                x_seq <= x_seq + 1;
            end else if (x_prev == 1 && x_seq == 0) begin
                x_seq <= x_seq + 1;
            end
        end else if (x_prev == 1 && x_seq == 2) begin
            x_seq <= x_seq + 1;
        end else begin
            x_seq <= 0;
        end
        x_prev <= x;
    end else begin
        x_seq <= 0;
        x_prev <= 0;
    end
end

reg [1:0] y_timer;
always @(posedge clk) begin
    if (!resetn) begin
        y_timer <= 0;
    end else if (state == MONITOR_Y) begin
        y_timer <= y_timer + 1;
    end else begin
        y_timer <= 0;
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = (resetn && x_seq != 3)? MONITOR_X : IDLE;
        MONITOR_X: next_state = (x_seq == 3)? MONITOR_Y : MONITOR_X;
        MONITOR_Y: next_state = (y || y_timer == 2)? MONITOR_Y : (y_timer == 2)? IDLE : MONITOR_Y;
    endcase
end

// Update g based on state
always @(posedge clk) begin
    if (!resetn) begin
        g <= 0;
    end else if (state == MONITOR_Y) begin
        if (y || g) begin
            g <= 1;
        end else if (y_timer == 2) begin
            g <= 0;
        end
    end
end

endmodule