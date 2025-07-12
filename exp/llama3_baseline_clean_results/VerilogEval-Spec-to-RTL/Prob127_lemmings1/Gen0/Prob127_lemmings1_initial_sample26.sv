module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] current_state; // Initialize state as 1-bit register
reg [0:0] next_state;

// Moore state machine outputs
assign walk_left = (current_state == 0);
assign walk_right = (current_state == 1);

// Next state logic
always @(*)
begin
    case(current_state)
        0: // Currently walking left
            begin
                if (bump_left)
                    next_state = 1; // Switch to walking right
                else
                    next_state = 0; // Keep walking left
            end
        1: // Currently walking right
            begin
                if (bump_right)
                    next_state = 0; // Switch to walking left
                else
                    next_state = 1; // Keep walking right
            end
        default: next_state = 0; // Default to walking left
    endcase

    // If both bump_left and bump_right are 1, switch directions
    if (bump_left && bump_right)
    begin
        next_state = ~current_state;
    end
end

// State register
always @(posedge clk or posedge areset)
begin
    if (areset)
        current_state <= 0; // Reset to walk left
    else
        current_state <= next_state;
end

endmodule