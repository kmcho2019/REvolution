module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [4:0] fall_counter;  // Counter to keep track of the number of clock cycles the Lemming has been falling
reg current_state;  // Current state of the Lemming (0: WALK_LEFT, 1: WALK_RIGHT)
reg previous_state;  // Previous state of the Lemming (0: WALK_LEFT, 1: WALK_RIGHT)
reg splattered;  // Flag to indicate if the Lemming has splattered

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0;  // Reset to WALK_LEFT state
        previous_state <= 0;  // Reset to WALK_LEFT state
        fall_counter <= 0;  // Reset fall counter
        splattered <= 0;  // Reset splattered flag
    end else if (splattered) begin
        // If the Lemming has splattered, do nothing
    end else if (!ground) begin
        if (fall_counter > 20) begin
            splattered <= 1;  // Set splattered flag if the Lemming has been falling for more than 20 clock cycles
        end else begin
            fall_counter <= fall_counter + 1;  // Increment fall counter
        end
    end else if (dig && (current_state == 0 || current_state == 1)) begin
        // If the Lemming is told to dig and is walking, start digging
    end else if (bump_left && current_state == 1) begin
        current_state <= 0;  // Switch to WALK_LEFT state if the Lemming is bumped on the left
    end else if (bump_right && current_state == 0) begin
        current_state <= 1;  // Switch to WALK_RIGHT state if the Lemming is bumped on the right
    end else if (dig && (current_state == 0 || current_state == 1)) begin
        // If the Lemming is told to dig and is walking, start digging
    end else begin
        fall_counter <= 0;  // Reset fall counter if the Lemming is not falling
        previous_state <= current_state;  // Update previous state
    end
end

always @(*) begin
    if (splattered) begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else if (!ground) begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 1;
        digging <= 0;
    end else if (dig && (current_state == 0 || current_state == 1)) begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 0;
        digging <= 1;
    end else if (current_state == 0) begin
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        walk_left <= 0;
        walk_right <= 1;
        aaah <= 0;
        digging <= 0;
    end
end

endmodule