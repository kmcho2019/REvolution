module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Enum for states
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Previous walking direction
reg prev_walk_left;

// Counter for falling clock cycles
reg [5:0] fall_counter;

// Whether the Lemming has splattered
reg splattered;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        prev_walk_left <= 1'b1;
        splattered <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_walk_left <= 1'b1;
                end else if (dig == 1'b1) begin
                    state <= DIGGING;
                    prev_walk_left <= 1'b1;
                end else if (bump_left == 1'b1 || (bump_left == 1'b0 && bump_right == 1'b1)) begin
                    state <= WALK_RIGHT;
                end else begin
                    state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_walk_left <= 1'b0;
                end else if (dig == 1'b1) begin
                    state <= DIGGING;
                    prev_walk_left <= 1'b0;
                end else if (bump_right == 1'b1 || (bump_right == 1'b0 && bump_left == 1'b1)) begin
                    state <= WALK_LEFT;
                end else begin
                    state <= WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                    end else if (prev_walk_left == 1'b1) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                    state <= FALLING;
                end
            end
            DIGGING: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_walk_left <= prev_walk_left;
                end else if (prev_walk_left == 1'b1) begin
                    state <= WALK_LEFT;
                end else begin
                    state <= WALK_RIGHT;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == SPLATTERED) begin
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            WALK_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            FALLING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            DIGGING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            default: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule