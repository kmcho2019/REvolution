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

reg [4:0] fall_counter;
reg fall_state;
reg digging_state;
reg walk_direction;
reg new_walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        fall_counter <= 5'b0;
        fall_state <= 1'b0;
        digging_state <= 1'b0;
        walk_direction <= 1'b0;
    end else begin
        if (~ground) begin
            // If there's no ground, the Lemming falls
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
            fall_counter <= fall_counter + 1'b1;
            fall_state <= 1'b1;
            digging_state <= 1'b0;
        end else if (dig &&!aaah &&!digging_state) begin
            // If dig is asserted and the Lemming is not falling or digging, start digging
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
            fall_state <= 1'b0;
            digging_state <= 1'b1;
        end else if (fall_state && ground) begin
            // If the Lemming hits the ground after falling
            if (fall_counter > 5'd20) begin
                // If the fall duration exceeds 20 cycles, the Lemming splatters
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end else begin
                // Otherwise, the Lemming resumes walking in the original direction
                walk_left <= walk_direction? 1'b0 : 1'b1;
                walk_right <= walk_direction? 1'b1 : 1'b0;
                aaah <= 1'b0;
            end
            fall_counter <= 5'b0;
            fall_state <= 1'b0;
        end else if (digging_state &&!ground) begin
            // If the Lemming is digging and the ground disappears, it falls
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
            fall_counter <= fall_counter + 1'b1;
            fall_state <= 1'b1;
            digging_state <= 1'b0;
        end else if ((bump_left && walk_direction) || (bump_right &&!walk_direction)) begin
            // If the Lemming is bumped, switch its walking direction
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
        end else begin
            // Default case: maintain the current state
            if (walk_direction) begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end else begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            aaah <= 1'b0;
        end
    end
end

endmodule