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
        // Update f and g based on state
        case (state)
            SET_F: begin
                f <= 1;
                g <= 0;
            end
            MONITOR_Y: g <= 1;
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

// Combinational logic to determine next state
reg [1:0] x_counter;
always @(posedge clk) begin
    if (!resetn) begin
        x_counter <= 0;
    end else if (state == MONITOR_X) begin
        if (x) begin
            x_counter <= x_counter + 1;
        end else begin
            x_counter <= 0;
        end
    end else begin
        x_counter <= 0;
    end
end

reg [1:0] y_timer;
always @(posedge clk) begin
    if (!resetn) begin
        y_timer <= 0;
    end else if (state == MONITOR_Y) begin
        if (y) begin
            y_timer <= 0;
        end else if (y_timer < 2) begin
            y_timer <= y_timer + 1;
        end
    end else begin
        y_timer <= 0;
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = (resetn)? SET_F : IDLE;
        SET_F: next_state = MONITOR_X;
        MONITOR_X: next_state = (x_counter == 3)? MONITOR_Y : MONITOR_X;
        MONITOR_Y: next_state = (y_timer == 2)? IDLE : MONITOR_Y;
    endcase
end

endmodule