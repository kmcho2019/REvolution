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
parameter walking_left = 2'b00;
parameter walking_right = 2'b01;
parameter falling = 2'b10;
parameter digging_state = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize the current state
initial current_state = walking_left;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walking_left;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        walking_left: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_state;
            end else if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_left; // stay in the same state
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_state;
            end else if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                // go back to the previous state
                if (bump_left) begin
                    next_state = walking_right;
                end else if (bump_right) begin
                    next_state = walking_left;
                end else if (current_state == walking_left) begin
                    next_state = walking_left;
                end else if (current_state == walking_right) begin
                    next_state = walking_right;
                end else begin
                    next_state = walking_left; // default state
                end
            end else begin
                next_state = falling;
            end
        end
        digging_state: begin
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging_state;
            end
        end
        default: next_state = walking_left;
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
        walking_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        walking_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        digging_state: begin
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