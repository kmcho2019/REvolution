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
parameter FALL = 2'b10;
parameter DIG = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the walking direction
reg direction;

// Define the output signals
reg walk_left_out;
reg walk_right_out;
reg aaah_out;
reg digging_out;

// Initialize the output signals
assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;
assign digging = digging_out;

// Moore state machine logic
always @(*) begin
    // Determine the next state
    case (current_state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIG;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIG;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL: begin
            if (ground) begin
                if (direction) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALL;
            end
        end
        DIG: begin
            if (!ground) begin
                next_state = FALL;
            end else begin
                next_state = DIG;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase

    // Determine the output signals
    case (current_state)
        WALK_LEFT: begin
            walk_left_out = 1'b1;
            walk_right_out = 1'b0;
            aaah_out = 1'b0;
            digging_out = 1'b0;
            direction = 1'b1;
        end
        WALK_RIGHT: begin
            walk_left_out = 1'b0;
            walk_right_out = 1'b1;
            aaah_out = 1'b0;
            digging_out = 1'b0;
            direction = 1'b0;
        end
        FALL: begin
            walk_left_out = 1'b0;
            walk_right_out = 1'b0;
            aaah_out = 1'b1;
            digging_out = 1'b0;
        end
        DIG: begin
            walk_left_out = 1'b0;
            walk_right_out = 1'b0;
            aaah_out = 1'b0;
            digging_out = 1'b1;
        end
        default: begin
            walk_left_out = 1'b1;
            walk_right_out = 1'b0;
            aaah_out = 1'b0;
            digging_out = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

endmodule