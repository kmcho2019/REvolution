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
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (bump_left && bump_right) begin
                    if (current_state == IDLE_LEFT) begin
                        next_state = IDLE_RIGHT;
                    end else begin
                        next_state = IDLE_LEFT;
                    end
                end else if (current_state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
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
        FALLING: begin
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