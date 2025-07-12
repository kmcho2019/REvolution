module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;
parameter RESET = 2'b11;

// Register to hold current state
reg [1:0] state;
reg [1:0] nextState;

// Register to hold previous walking direction
reg walk_direction;

// Combinational logic to determine next state
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                nextState = FALL;
            end else if (bump_left) begin
                nextState = WALK_RIGHT;
            end else if (bump_right) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_LEFT;
            end
            walk_direction = 1'b0;
        end
        WALK_RIGHT: begin
            if (!ground) begin
                nextState = FALL;
            end else if (bump_left) begin
                nextState = WALK_LEFT;
            end else if (bump_right) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_RIGHT;
            end
            walk_direction = 1'b1;
        end
        FALL: begin
            if (ground) begin
                if (walk_direction == 1'b0) begin
                    nextState = WALK_LEFT;
                end else begin
                    nextState = WALK_RIGHT;
                end
            end else begin
                nextState = FALL;
            end
        end
        default: begin
            nextState = WALK_LEFT;
        end
    endcase
end

// Sequential logic to update state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= nextState;
    end
end

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALL);

endmodule