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
    output reg digging_output
);

// Define states
enum logic [2:0] {
    walking = 3'b000,
    falling = 3'b001,
    digging_state = 3'b010,
    splattered = 3'b011
} state, next_state;

// Define variables
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking;
        fall_counter <= 5'b0;
        direction <= 1'b0;
    end else begin
        case (state)
            walking: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= digging_state;
                end else if ((bump_left && !bump_right) || (bump_left && bump_right && !direction)) begin
                    direction <= 1'b1;
                end else if ((bump_right && !bump_left) || (bump_left && bump_right && direction)) begin
                    direction <= 1'b0;
                end
            end
            falling: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= splattered;
                    end else begin
                        state <= walking;
                    end
                end
            end
            digging_state: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                end
            end
            splattered: begin
                // do nothing
            end
        endcase
    end
end

// Combinational logic
always @(*) begin
    walk_left = (state == walking && !direction);
    walk_right = (state == walking && direction);
    aaah = (state == falling);
    digging_output = (state == digging_state);
end

endmodule