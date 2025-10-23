module TopModule (
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

// Define states
enum logic [2:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Define the walking direction
logic [1:0] walk_dir;

// Define a counter for the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

// Output logic
assign walk_left = (state == WALK_LEFT && state != FALLING) || (state == DIGGING && walk_dir == 1'b0);
assign walk_right = (state == WALK_RIGHT && state != FALLING) || (state == DIGGING && walk_dir == 1'b1);
assign aaah = state == FALLING;
assign digging = state == DIGGING;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_dir <= 1'b0;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        walk_dir <= (state == WALK_LEFT) ? 1'b0 : (state == WALK_RIGHT) ? 1'b1 : walk_dir;
        fall_counter <= (state == FALLING) ? fall_counter + 1 : 0;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        WALK_LEFT, WALK_RIGHT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (dig == 1) begin
                next_state = DIGGING;
                walk_dir = (state == WALK_LEFT) ? 1'b0 : 1'b1;
            end else if (bump_left == 1 && bump_right == 0) begin
                next_state = WALK_RIGHT;
            end else if (bump_left == 0 && bump_right == 1) begin
                next_state = WALK_LEFT;
            end else if (bump_left == 1 && bump_right == 1) begin
                next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
            end else begin
                next_state = state;
            end
        end
        FALLING: begin
            if (ground == 1) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (dig == 1) begin
                    next_state = DIGGING;
                end else begin
                    next_state = (walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

endmodule