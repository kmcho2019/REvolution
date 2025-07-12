module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
localparam WL = 2'b00; // walking left
localparam WR = 2'b01; // walking right
localparam F = 2'b10;  // falling

reg [1:0] current_state;
reg [1:0] next_state;

// Determine the next state
always_comb begin
    case (current_state)
        WL: begin
            if (bump_left) next_state = WR;
            else if (!ground) next_state = F;
            else next_state = WL;
        end
        WR: begin
            if (bump_right) next_state = WL;
            else if (!ground) next_state = F;
            else next_state = WR;
        end
        F: begin
            if (ground) next_state = (bump_left || bump_right) ? (bump_left ? WL : WR) : (current_state == WL ? WL : WR);
            else next_state = F;
        end
        default: next_state = WL;
    endcase
end

// Update the current state
always @(posedge clk or posedge areset) begin
    if (areset) current_state <= WL;
    else current_state <= next_state;
end

// Determine the output based on the current state
always_comb begin
    walk_left = (current_state == WL);
    walk_right = (current_state == WR);
    aaah = (current_state == F);
end

endmodule