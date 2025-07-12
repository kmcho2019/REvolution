module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state;
reg [1:0] next_state;

// Combinational logic for state transitions
always @(*) begin
    next_state = state;

    case(state)
        2'b01: // walking left
            begin
                if (~ground) begin
                    next_state = 2'b11; // falling
                end else if (bump_left) begin
                    next_state = 2'b10; // walking right
                end
            end
        2'b10: // walking right
            begin
                if (~ground) begin
                    next_state = 2'b11; // falling
                end else if (bump_right) begin
                    next_state = 2'b01; // walking left
                end
            end
        2'b11: // falling
            begin
                if (ground) begin
                    // When ground reappears, resume walking in the previous direction
                    // Since we don't have a separate direction controller, we need to 
                    // use an additional variable to keep track of the previous direction
                    reg prev_direction;
                    if (prev_direction == 1'b0) begin
                        next_state = 2'b01; // walking left
                    end else begin
                        next_state = 2'b10; // walking right
                    end
                end
            end
    endcase

    // Update prev_direction
    always @(posedge clk) begin
        if (state == 2'b01) begin
            prev_direction = 1'b0; // walking left
        end else if (state == 2'b10) begin
            prev_direction = 1'b1; // walking right
        end
    end
end

// However, the above code has an issue: it uses a reg variable inside an always block.
// We need to declare the reg variable outside the always block.

reg prev_direction;

// Combinational logic for state transitions
always @(*) begin
    next_state = state;

    case(state)
        2'b01: // walking left
            begin
                if (~ground) begin
                    next_state = 2'b11; // falling
                end else if (bump_left || bump_right) begin
                    next_state = 2'b10; // walking right
                end
            end
        2'b10: // walking right
            begin
                if (~ground) begin
                    next_state = 2'b11; // falling
                end else if (bump_left || bump_right) begin
                    next_state = 2'b01; // walking left
                end
            end
        2'b11: // falling
            begin
                if (ground) begin
                    // When ground reappears, resume walking in the previous direction
                    if (prev_direction == 1'b0) begin
                        next_state = 2'b01; // walking left
                    end else begin
                        next_state = 2'b10; // walking right
                    end
                end
            end
    endcase
end

// Sequential logic to update state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to walking left
        prev_direction <= 1'b0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Update prev_direction
always @(posedge clk) begin
    if (state == 2'b01) begin
        prev_direction <= 1'b0; // walking left
    end else if (state == 2'b10) begin
        prev_direction <= 1'b1; // walking right
    end
end

// Output logic
always @(*) begin
    walk_left = (state == 2'b01);
    walk_right = (state == 2'b10);
    aaah = (state == 2'b11);
end

endmodule