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

reg walk_direction;
reg [4:0] fall_counter;
reg fall_state;
reg digging_state;
reg new_walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        walk_direction <= 1'b0;
        fall_counter <= 5'b0;
        fall_state <= 1'b0;
        digging_state <= 1'b0;
    end else begin
        if (~ground) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
            fall_counter <= fall_counter + 1'b1;
            fall_state <= 1'b1;
            digging_state <= 1'b0;
        end else if (dig &&!aaah &&!digging_state) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
            fall_state <= 1'b0;
            digging_state <= 1'b1;
        end else if ((bump_left && walk_direction) || (bump_right &&!walk_direction)) begin
            new_walk_direction <= ~walk_direction;
            walk_direction <= new_walk_direction;
            if (new_walk_direction) begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end else begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            fall_state <= 1'b0;
            digging_state <= 1'b0;
        end else if (fall_counter > 5'd20 && ground) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            fall_state <= 1'b0;
            digging_state <= 1'b0;
        end else if (ground && aaah) begin
            walk_left <= walk_direction? 1'b0 : 1'b1;
            walk_right <= walk_direction? 1'b1 : 1'b0;
            aaah <= 1'b0;
            fall_counter <= 5'b0;
            fall_state <= 1'b0;
            digging_state <= 1'b0;
        end else if (ground && digging_state &&!dig) begin
            walk_left <= walk_direction? 1'b0 : 1'b1;
            walk_right <= walk_direction? 1'b1 : 1'b0;
            digging <= 1'b0;
            fall_state <= 1'b0;
            digging_state <= 1'b0;
        end
    end
end

endmodule