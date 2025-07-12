module TopModule (
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

reg [1:0] state; // 2-bit state variable
reg [1:0] nextState; // next state variable

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;
parameter DIG = 2'b11;

// Determine next state
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin // ground disappears
                nextState = FALL;
            end else if (dig) begin // start digging
                nextState = DIG;
            end else if (bump_right) begin // bump on the right
                nextState = WALK_RIGHT;
            end else if (bump_left) begin // bump on the left (no change in this case)
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_LEFT; // no change
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin // ground disappears
                nextState = FALL;
            end else if (dig) begin // start digging
                nextState = DIG;
            end else if (bump_left) begin // bump on the left
                nextState = WALK_LEFT;
            end else if (bump_right) begin // bump on the right (no change in this case)
                nextState = WALK_RIGHT;
            end else begin
                nextState = WALK_RIGHT; // no change
            end
        end
        FALL: begin
            if (ground) begin // ground reappears
                if (state == WALK_LEFT) begin
                    nextState = WALK_LEFT;
                end else begin
                    nextState = WALK_RIGHT;
                end
            end else begin
                nextState = FALL; // continue falling
            end
        end
        DIG: begin
            if (!ground) begin // ground disappears
                nextState = FALL;
            end else begin
                nextState = DIG; // continue digging
            end
        end
        default: begin
            nextState = WALK_LEFT; // default to WALK_LEFT
        end
    endcase
end

// Update state on positive edge of clock
always @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset
        state <= WALK_LEFT;
    end else begin
        state <= nextState;
    end
end

// Determine output signals
always @(*) begin
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
        FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIG: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule