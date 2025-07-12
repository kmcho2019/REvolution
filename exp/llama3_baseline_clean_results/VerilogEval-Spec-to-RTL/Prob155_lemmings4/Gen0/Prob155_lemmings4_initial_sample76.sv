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

// Define states
parameter IDLE_LEFT = 4'b0001;
parameter IDLE_RIGHT = 4'b0010;
parameter FALLING = 4'b0100;
parameter DIGGING = 4'b1000;
parameter SPLATTERED = 4'b0000;

// Define state register
reg [3:0] state;
reg [3:0] next_state;

// Define counter for falling time
reg [5:0] falling_counter;
reg [5:0] next_falling_counter;

// Define current walking direction
reg walk_dir;
reg next_walk_dir;

// Output logic
assign walk_left = (state == IDLE_LEFT) && (walk_dir == 1'b1);
assign walk_right = (state == IDLE_RIGHT) && (walk_dir == 1'b0);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

// State transition logic
always @(*) begin
    next_state = state;
    next_falling_counter = falling_counter;
    next_walk_dir = walk_dir;

    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                next_falling_counter = 1'b1;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
                next_walk_dir = 1'b0;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
                next_walk_dir = 1'b0;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end

        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                next_falling_counter = 1'b1;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
                next_walk_dir = 1'b1;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
                next_walk_dir = 1'b1;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end

        FALLING: begin
            if (ground) begin
                if (falling_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (walk_dir) begin
                        next_state = IDLE_LEFT;
                    end else begin
                        next_state = IDLE_RIGHT;
                    end
                end
            end else begin
                next_falling_counter = falling_counter + 1'b1;
            end
        end

        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_falling_counter = 1'b1;
            end
        end

        SPLATTERED: begin
            next_state = SPLATTERED;
        end

        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        walk_dir <= 1'b1;
        falling_counter <= 0;
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
        falling_counter <= next_falling_counter;
    end
end

endmodule