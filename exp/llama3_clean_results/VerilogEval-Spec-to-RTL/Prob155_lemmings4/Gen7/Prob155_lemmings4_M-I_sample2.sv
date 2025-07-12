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
enum logic [2:0] {
    IDLE = 3'b000,
    WALKING = 3'b001,
    FALLING = 3'b010,
    DIGGING = 3'b011,
    SPLATTERED = 3'b100
} state, next_state;

// Define variables
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (ground) begin
                    state <= WALKING;
                end
            end
            WALKING: begin
                if (dig && ground) begin
                    state <= DIGGING;
                end else if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (bump_left && bump_right) begin
                    direction <= ~direction;
                end else if (bump_left) begin
                    direction <= 1'b1;
                end else if (bump_right) begin
                    direction <= 1'b0;
                end
                if (direction) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            DIGGING: begin
                digging <= 1'b1;
                if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                aaah <= 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                    fall_counter <= 5'b0;
                end
            end
            SPLATTERED: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule