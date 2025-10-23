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

// Define the states
parameter walking_left = 2'b00;
parameter walking_right = 2'b01;
parameter falling = 2'b10;
parameter digging_left = 2'b11;
parameter digging_right = 2'b12;

// Declare the current and next states
reg [1:0] state, next_state;

// Initialize the state
initial state = walking_left;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        walking_left: begin
            if (!ground) begin
                next_state <= falling;
            end else if (dig) begin
                next_state <= digging_left;
            end else if (bump_left) begin
                next_state <= walking_right;
            end else if (bump_right) begin
                next_state <= walking_left;
            end else begin
                next_state <= walking_left;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state <= falling;
            end else if (dig) begin
                next_state <= digging_right;
            end else if (bump_left) begin
                next_state <= walking_left;
            end else if (bump_right) begin
                next_state <= walking_right;
            end else begin
                next_state <= walking_right;
            end
        end
        falling: begin
            if (ground) begin
                next_state <= walking_left;
            end else begin
                next_state <= falling;
            end
        end
        digging_left: begin
            if (!ground) begin
                next_state <= falling;
            end else begin
                next_state <= digging_left;
            end
        end
        digging_right: begin
            if (!ground) begin
                next_state <= falling;
            end else begin
                next_state <= digging_right;
            end
        end
        default: next_state <= walking_left;
    endcase
end

// Output logic
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        walking_left: begin
            walk_left = 1;
        end
        walking_right: begin
            walk_right = 1;
        end
        falling: begin
            aaah = 1;
        end
        digging_left: begin
            digging = 1;
            walk_left = 1;
        end
        digging_right: begin
            digging = 1;
            walk_right = 1;
        end
        default: ;
    endcase
end

endmodule