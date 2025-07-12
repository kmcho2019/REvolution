module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

typedef enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state_t;

state_t current_state, next_state;
reg a_sync;

// Synchronize input to clock domain
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_sync <= 1'b0;
    end else begin
        a_sync <= a;
    end
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (a_sync && !a) begin
                next_state = RISING;
            end else if (!a_sync && a) begin
                next_state = FALLING;
            end else begin
                next_state = IDLE;
            end
        end
        RISING: next_state = IDLE;
        FALLING: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        rise <= (next_state == RISING);
        down <= (next_state == FALLING);
    end
end

endmodule