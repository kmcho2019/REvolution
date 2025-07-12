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
    walking = 2'b00,
    falling = 2'b01,
    splattered = 2'b10
} state, next_state;

// Define sub-states for walking
enum logic {
    left = 1'b0,
    right = 1'b1
} direction, next_direction;

// Define variables
reg [5:0] fall_counter;
reg [5:0] dig_counter;
reg is_digging;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking;
        direction <= left;
        fall_counter <= 6'b0;
        dig_counter <= 6'b0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            walking: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 6'b1;
                end else if (dig) begin
                    is_digging <= 1'b1;
                    dig_counter <= 6'b1;
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
                        dig_counter <= 6'b0;
                    end
                end
            end
            splattered: begin
                // do nothing
            end
        endcase
    end
end

// Assign outputs directly
assign walk_left = (state == walking) && (direction == left) &&!is_digging;
assign walk_right = (state == walking) && (direction == right) &&!is_digging;
assign aaah = (state == falling);
assign digging = (state == walking) && is_digging;

endmodule