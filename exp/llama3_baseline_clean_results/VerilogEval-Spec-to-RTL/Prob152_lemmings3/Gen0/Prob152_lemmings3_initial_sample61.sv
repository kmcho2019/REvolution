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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the output signals
reg walk_left_out;
reg walk_right_out;
reg aaah_out;
reg digging_out;

// Assign output signals based on current state
always @(*) begin
    walk_left_out = (current_state == WALK_LEFT);
    walk_right_out = (current_state == WALK_RIGHT);
    aaah_out = (current_state == FALLING);
    digging_out = (current_state == DIGGING);
end

// Assign next state based on current state and inputs
always @(*) begin
    case (current_state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (current_state == FALLING) begin
                    if (dig) begin
                        next_state = DIGGING;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Update current state on positive edge of clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Assign output signals
assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;
assign digging = digging_out;

endmodule