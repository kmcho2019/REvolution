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
    idle = 3'b000,
    walking_left = 3'b001,
    walking_right = 3'b010,
    falling = 3'b011,
    digging_left = 3'b100,
    digging_right = 3'b101,
    splattered = 3'b110
} state, next_state;

// Define variables
reg [4:0] fall_counter;
reg [2:0] direction;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
        fall_counter <= 5'b0;
        direction <= walking_left;
    end else begin
        case (state)
            walking_left: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                    direction <= walking_left;
                end else if (dig) begin
                    state <= digging_left;
                end else if (bump_left) begin
                    state <= walking_right;
                end else if (bump_right) begin
                    // do nothing
                end else begin
                    // do nothing
                end
            end
            walking_right: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                    direction <= walking_right;
                end else if (dig) begin
                    state <= digging_right;
                end else if (bump_right) begin
                    state <= walking_left;
                end else if (bump_left) begin
                    // do nothing
                end else begin
                    // do nothing
                end
            end
            falling: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= splattered;
                    end else if (direction == walking_left) begin
                        state <= walking_left;
                    end else begin
                        state <= walking_right;
                    end
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            digging_left: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                    direction <= walking_left;
                end else begin
                    // do nothing
                end
            end
            digging_right: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 5'b1;
                    direction <= walking_right;
                end else begin
                    // do nothing
                end
            end
            splattered: begin
                // do nothing
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

// Combinational logic
always @(*) begin
    walk_left = (state == walking_left);
    walk_right = (state == walking_right);
    aaah = (state == falling);
    digging = (state == digging_left || state == digging_right);
end

endmodule