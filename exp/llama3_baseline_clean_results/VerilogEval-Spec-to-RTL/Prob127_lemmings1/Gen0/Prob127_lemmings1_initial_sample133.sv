module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Define the current state
reg state;
reg next_state;

// Define the outputs
reg walk_left_reg;
reg walk_right_reg;

// Update the state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Determine the next state based on the current state and inputs
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if(bump_left) begin
                next_state <= WALK_RIGHT;
            end else if(bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if(bump_right) begin
                next_state <= WALK_LEFT;
            end else if(bump_left) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        default: begin
            next_state <= WALK_LEFT;
        end
    endcase
end

// Determine the output based on the current state
always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left_reg <= 1'b1;
            walk_right_reg <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left_reg <= 1'b0;
            walk_right_reg <= 1'b1;
        end
        default: begin
            walk_left_reg <= 1'b1;
            walk_right_reg <= 1'b0;
        end
    endcase
end

// Assign the outputs
assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;

endmodule