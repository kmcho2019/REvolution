module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define states
enum logic [1:0] {
    IDLE = 2'b00,
    WALKING = 2'b01,
    FALLING = 2'b10,
    SPLATTERED = 2'b11
} state, next_state;

// Define variables
reg direction; // 0 for left, 1 for right
reg [4:0] fall_counter;
reg is_digging;

// Combinational logic for next state
always_comb begin
    case (state)
        IDLE: begin
            if (ground) begin
                next_state = WALKING;
            end else begin
                next_state = IDLE;
            end
        end
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig && !is_digging) begin
                next_state = WALKING;
                is_digging = 1'b1;
            end else if (bump_left) begin
                next_state = WALKING;
                direction = 1'b1;
            end else if (bump_right) begin
                next_state = WALKING;
                direction = 1'b0;
            end else begin
                next_state = WALKING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                    is_digging = 1'b0;
                end
            end else begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Combinational logic for outputs
always_comb begin
    case (state)
        IDLE: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALKING: begin
            if (direction) begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end else begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
            aaah = 1'b0;
            digging = is_digging;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        direction <= 1'b0;
        fall_counter <= 5'b0;
        is_digging <= 1'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

endmodule