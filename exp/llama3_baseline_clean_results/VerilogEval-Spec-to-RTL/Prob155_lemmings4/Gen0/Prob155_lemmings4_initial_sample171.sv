module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states of the Moore state machine
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Define the direction of the Lemming
logic direction_left;

// Define the counter for falling
logic [5:0] fall_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction_left <= 1'b1;
        fall_counter <= 6'b000000;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                end else if (dig == 1'b1) begin
                    state <= DIGGING;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    direction_left <= ~direction_left;
                    if (direction_left) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                end else if (dig == 1'b1) begin
                    state <= DIGGING;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    direction_left <= ~direction_left;
                    if (direction_left) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground == 1'b1) begin
                    if (fall_counter > 6'b10100) begin
                        state <= SPLATTERED;
                    end else if (direction_left) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                    fall_counter <= 6'b000000;
                end
            end
            DIGGING: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                end else if (dig == 1'b0) begin
                    if (direction_left) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule