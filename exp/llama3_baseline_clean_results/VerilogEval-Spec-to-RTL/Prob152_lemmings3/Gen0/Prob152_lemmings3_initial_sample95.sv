module TopModule (
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

// Define the states
enum logic [1:0] {
    WL, // Walking Left
    WR, // Walking Right
    F,  // Falling
    D   // Digging
} state, next_state;

// Default output values
assign walk_left = 0;
assign walk_right = 0;
assign aaah = 0;
assign digging = 0;

// Current state logic
always_comb begin
    case (state)
        WL: begin
            walk_left = 1;
            if (!ground) next_state = F;
            else if (bump_left) next_state = WR;
            else if (bump_right) next_state = WL;
            else if (dig) next_state = D;
            else next_state = WL;
        end
        WR: begin
            walk_right = 1;
            if (!ground) next_state = F;
            else if (bump_left) next_state = WR;
            else if (bump_right) next_state = WL;
            else if (dig) next_state = D;
            else next_state = WR;
        end
        F: begin
            aaah = 1;
            if (ground) begin
                if (state == D) next_state = state == D ? WL : WR;
                else next_state = state == WL ? WL : WR;
            end
            else next_state = F;
        end
        D: begin
            digging = 1;
            walk_left = state == D && state == WL ? 1 : 0;
            walk_right = state == D && state == WR ? 1 : 0;
            if (!ground) next_state = F;
            else next_state = D;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= WL;
    else state <= next_state;
end

endmodule