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
    idle = 2'b00,
    walking = 2'b01,
    falling = 2'b10,
    splattered = 2'b11
} state, next_state;

// Define sub-states for walking
enum logic {
    left = 1'b0,
    right = 1'b1
} direction, next_direction;

// Define variables
reg [5:0] fall_counter;
reg is_digging;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= idle;
        direction <= left;
        fall_counter <= 6'b0;
        is_digging <= 1'b0;
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            idle: begin
                if (ground) begin
                    state <= walking;
                end
            end
            walking: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 6'b1;
                end else if (dig) begin
                    is_digging <= 1'b1;
                end else if (bump_left ^ bump_right) begin
                    direction <= ~direction;
                end
            end
            falling: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 6'd20) begin
                        state <= splattered;
                    end else begin
                        state <= walking;
                        is_digging <= 1'b0;
                    end
                end
            end
            splattered: begin
                // do nothing
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    walk_left = (state == walking) && (direction == left) &&!is_digging;
    walk_right = (state == walking) && (direction == right) &&!is_digging;
    aaah = (state == falling);
    digging = (state == walking) && is_digging;
end

endmodule