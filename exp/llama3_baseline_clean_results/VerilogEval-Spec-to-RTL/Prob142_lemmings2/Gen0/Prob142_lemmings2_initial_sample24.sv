module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// State variable
reg [1:0] state;
reg [1:0] nextState;

// Output signals
reg walk_left_reg;
reg walk_right_reg;
reg aaah_reg;

// Combinational logic for next state and output signals
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (ground == 0) begin
                nextState = FALLING;
            end else if (bump_left == 1 || bump_right == 1) begin
                nextState = WALK_RIGHT;
            end else begin
                nextState = WALK_LEFT;
            end
            walk_left_reg = 1;
            walk_right_reg = 0;
            aaah_reg = 0;
        end
        WALK_RIGHT: begin
            if (ground == 0) begin
                nextState = FALLING;
            end else if (bump_left == 1 || bump_right == 1) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_RIGHT;
            end
            walk_left_reg = 0;
            walk_right_reg = 1;
            aaah_reg = 0;
        end
        FALLING: begin
            if (ground == 1) begin
                // Resume walking in the same direction as before the fall
                if (bump_left ==  && bump_right == 0) begin
                    if (walk_left_reg == 1) begin
                        nextState = WALK_LEFT;
                    end else begin
                        nextState = WALK_RIGHT;
                    end
                end else begin
                    // If bumped while falling or when ground reappears, do not change direction
                    if (walk_left_reg == 1) begin
                        nextState = WALK_LEFT;
                    end else begin
                        nextState = WALK_RIGHT;
                    end
                end
            end else begin
                nextState = FALLING;
            end
            walk_left_reg = walk_left_reg;
            walk_right_reg = walk_right_reg;
            aaah_reg = 1;
        end
        default: begin
            nextState = WALK_LEFT;
            walk_left_reg = 1;
            walk_right_reg = 0;
            aaah_reg = 0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset == 1) begin
        state <= WALK_LEFT;
        walk_left_reg <= 1;
        walk_right_reg <= 0;
        aaah_reg <= 0;
    end else begin
        state <= nextState;
    end
end

// Output assignments
assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;

endmodule