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
parameter IDLE_LEFT = 3'b001;
parameter IDLE_RIGHT = 3'b010;
parameter FALLING_LEFT = 3'b011;
parameter FALLING_RIGHT = 3'b100;

// Define the current state
reg [2:0] state;
reg [2:0] nextState;

// Determine the next state
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            if (bump_right) begin
                nextState = IDLE_RIGHT;
            end else if (bump_left) begin
                nextState = IDLE_RIGHT;
            end else if (!ground) begin
                nextState = FALLING_LEFT;
            end else begin
                nextState = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (bump_left) begin
                nextState = IDLE_LEFT;
            end else if (bump_right) begin
                nextState = IDLE_LEFT;
            end else if (!ground) begin
                nextState = FALLING_RIGHT;
            end else begin
                nextState = IDLE_RIGHT;
            end
        end
        FALLING_LEFT: begin
            if (ground) begin
                nextState = IDLE_LEFT;
            end else begin
                nextState = FALLING_LEFT;
            end
        end
        FALLING_RIGHT: begin
            if (ground) begin
                nextState = IDLE_RIGHT;
            end else begin
                nextState = FALLING_RIGHT;
            end
        end
        default: nextState = IDLE_LEFT;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= nextState;
    end
end

// Determine the output signals
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        FALLING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule