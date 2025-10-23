module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL_LEFT = 2'b10;
parameter FALL_RIGHT = 2'b11;

// Combinational logic to determine next state
always @(*)
begin
    case (state)
        WALK_LEFT:
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        WALK_RIGHT:
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        FALL_LEFT:
            if (ground) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = FALL_LEFT;
            end
        FALL_RIGHT:
            if (ground) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = FALL_RIGHT;
            end
        default:
            next_state = WALK_LEFT;
    endcase
end

// Sequential logic to update state
always @(posedge clk or posedge areset)
begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*)
begin
    case (state)
        WALK_LEFT:
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        WALK_RIGHT:
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        FALL_LEFT:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        FALL_RIGHT:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        default:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
    endcase
end

endmodule