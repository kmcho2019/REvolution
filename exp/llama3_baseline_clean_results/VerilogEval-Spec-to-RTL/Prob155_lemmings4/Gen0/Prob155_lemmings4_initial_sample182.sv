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

// State machine for activity
reg [1:0] state; // 2 bits for 4 states: WALKING, FALLING, DIGGING, SPLATTERED
reg [1:0] next_state;

// State machine for direction
reg direction; // 1 bit for 2 states: LEFT, RIGHT
reg next_direction;

// Counter for falling clock cycles
reg [4:0] fall_counter;
reg [4:0] next_fall_counter;

// Initialize state and direction
initial state = 2'b00; // WALKING
initial direction = 1'b0; // LEFT
initial fall_counter = 5'b00000;

// State machine for activity
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        direction <= 1'b0; // LEFT
        fall_counter <= 5'b00000;
    end else begin
        state <= next_state;
        direction <= next_direction;
        fall_counter <= next_fall_counter;
    end
end

// Combinational logic for next state and direction
always @(*) begin
    next_state = state;
    next_direction = direction;
    next_fall_counter = fall_counter;

    case (state)
        2'b00: begin // WALKING
            if (!ground) begin
                next_state = 2'b01; // FALLING
                next_fall_counter = 5'b00001;
            end else if (dig && ground) begin
                next_state = 2'b10; // DIGGING
            end else if (bump_left && bump_right) begin
                next_direction = ~direction;
            end else if (bump_left) begin
                next_direction = 1'b1; // RIGHT
            end else if (bump_right) begin
                next_direction = 1'b0; // LEFT
            end
        end
        2'b01: begin // FALLING
            if (ground && fall_counter >= 5'b10100) begin
                next_state = 2'b11; // SPLATTERED
            end else if (ground) begin
                next_state = 2'b00; // WALKING
                next_fall_counter = 5'b00000;
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        2'b10: begin // DIGGING
            if (!ground) begin
                next_state = 2'b01; // FALLING
                next_fall_counter = 5'b00001;
            end
        end
        2'b11: begin // SPLATTERED
            // Do nothing, stay in this state
        end
    endcase
end

// Output logic
assign walk_left = (state == 2'b00 && direction == 1'b0 && !areset);
assign walk_right = (state == 2'b00 && direction == 1'b1 && !areset);
assign aaah = (state == 2'b01 && !areset);
assign digging = (state == 2'b10 && !areset);

endmodule