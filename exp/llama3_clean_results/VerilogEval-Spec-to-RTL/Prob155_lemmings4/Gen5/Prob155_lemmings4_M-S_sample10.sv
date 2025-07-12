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
    digging_state = 2'b10,
    splattered = 2'b11
} state, next_state;

// Define variables
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            walking: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                end else if (dig && ground) begin
                    state <= digging_state;
                end else if (bump_left || bump_right) begin
                    direction <= ~direction;
                end
            end
            digging_state: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                end
            end
            falling: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= splattered;
                    end else begin
                        state <= walking;
                        fall_counter <= 5'b0;
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
    if (state == splattered) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end else begin
        walk_left = (state == walking) && !direction;
        walk_right = (state == walking) && direction;
        aaah = (state == falling);
        digging = (state == digging_state);
    end
end

endmodule