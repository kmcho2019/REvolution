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

// State variables
reg [1:0] state;
reg [1:0] next_state;

// Output variables
reg walk_left_reg;
reg walk_right_reg;
reg aaah_reg;
reg digging_reg;

// State encoding
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Combinational logic for next state
always @(*)
begin
    case (state)
        IDLE_LEFT:
        begin
            if (!ground)
                next_state = FALLING;
            else if (dig)
                next_state = DIGGING;
            else if (bump_left)
                next_state = IDLE_RIGHT;
            else if (bump_right)
                next_state = IDLE_LEFT;
            else
                next_state = IDLE_LEFT;
        end
        IDLE_RIGHT:
        begin
            if (!ground)
                next_state = FALLING;
            else if (dig)
                next_state = DIGGING;
            else if (bump_left)
                next_state = IDLE_LEFT;
            else if (bump_right)
                next_state = IDLE_RIGHT;
            else
                next_state = IDLE_RIGHT;
        end
        FALLING:
        begin
            if (ground)
            begin
                if (state == FALLING && dig)
                    next_state = DIGGING;
                else if (state == FALLING && bump_left)
                    next_state = IDLE_RIGHT;
                else if (state == FALLING && bump_right)
                    next_state = IDLE_LEFT;
                else
                begin
                    if (walk_left_reg)
                        next_state = IDLE_LEFT;
                    else
                        next_state = IDLE_RIGHT;
                end
            end
            else
                next_state = FALLING;
        end
        DIGGING:
        begin
            if (!ground)
                next_state = FALLING;
            else
                next_state = DIGGING;
        end
        default:
            next_state = IDLE_LEFT;
    endcase
end

// Combinational logic for outputs
always @(*)
begin
    case (state)
        IDLE_LEFT:
        begin
            walk_left_reg = 1'b1;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
            digging_reg = 1'b0;
        end
        IDLE_RIGHT:
        begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b1;
            aaah_reg = 1'b0;
            digging_reg = 1'b0;
        end
        FALLING:
        begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b1;
            digging_reg = 1'b0;
        end
        DIGGING:
        begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
            digging_reg = 1'b1;
        end
        default:
        begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
            digging_reg = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= IDLE_LEFT;
        walk_left_reg <= 1'b1;
        walk_right_reg <= 1'b0;
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end
    else
    begin
        state <= next_state;
    end
end

assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

endmodule