module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, next_state;

// Asynchronous reset
always @(posedge areset) begin
    state <= IDLE_LEFT;
end

// Sequential logic
always @(posedge clk) begin
    state <= next_state;
end

// Combinational logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (bump_left || (bump_left && bump_right)) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (bump_right || (bump_left && bump_right)) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                next_state = state == DIGGING ? IDLE_LEFT : (state == IDLE_LEFT ? IDLE_LEFT : IDLE_RIGHT);
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

endmodule