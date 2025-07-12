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

// Define the current and next states
reg [1:0] current_state, next_state;

// Define the output signals
reg walk_left_out, walk_right_out, aaah_out, digging_out;

// Output logic
assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;
assign digging = digging_out;

// Combinational logic to generate next state
always @(*) begin
    // Default values
    walk_left_out = 0;
    walk_right_out = 0;
    aaah_out = 0;
    digging_out = 0;
    
    case(current_state)
        walking_left: begin
            walk_left_out = 1;
            if (~ground) begin
                next_state = falling;
            end else if (bump_left) begin
                next_state = walking_right;
            end else if (dig) begin
                next_state = digging_state;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            walk_right_out = 1;
            if (~ground) begin
                next_state = falling;
            end else if (bump_right) begin
                next_state = walking_left;
            end else if (dig) begin
                next_state = digging_state;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            aaah_out = 1;
            if (ground) begin
                // We need to keep track of the original direction before falling
                // We can't keep track of this information with just the 4 states, so
                // we can modify the 2 least significant bits to include this info
                if (current_state == {1'b0, walking_left}) begin
                    next_state = walking_left;
                end else if (current_state == {1'b0, walking_right}) begin
                    next_state = walking_right;
                end else if (current_state == {1'b1, walking_left}) begin
                    next_state = walking_left;
                end else if (current_state == {1'b1, walking_right}) begin
                    next_state = walking_right;
                end
            end else begin
                next_state = falling;
            end
        end
        digging_state: begin
            digging_out = 1;
            if (~ground) begin
                next_state = {1'b1, current_state};
            end else begin
                next_state = digging_state;
            end
        end
        default: next_state = walking_left;
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walking_left;
    end else begin
        current_state <= next_state;
    end
end

endmodule