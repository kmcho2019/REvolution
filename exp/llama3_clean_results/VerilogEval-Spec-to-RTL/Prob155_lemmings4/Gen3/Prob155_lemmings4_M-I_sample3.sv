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
enum logic [1:0] {
    walking = 2'b00,
    falling = 2'b01,
    splattered = 2'b11
} state, next_state;

// Define variables
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right
reg is_digging;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            walking: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    is_digging <= 1'b1;
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
    walk_left = (state == walking && !direction && !is_digging);
    walk_right = (state == walking && direction && !is_digging);
    aaah = (state == falling);
    digging_output = (state == walking && is_digging);
end

endmodule