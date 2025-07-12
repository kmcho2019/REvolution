module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define states
enum logic [1:0] {
    idle_left = 2'b00,
    idle_right = 2'b01,
    fall_left = 2'b10,
    fall_right = 2'b11
} state, next_state;

// Combinational logic for next state
always_comb begin
    case(state)
        idle_left: begin
            if (~ground) begin
                next_state = fall_left;
            end else if (bump_left) begin
                next_state = idle_right;
            end else if (bump_right) begin
                next_state = idle_left;
            end else begin
                next_state = idle_left;
            end
        end
        idle_right: begin
            if (~ground) begin
                next_state = fall_right;
            end else if (bump_left) begin
                next_state = idle_left;
            end else if (bump_right) begin
                next_state = idle_right;
            end else begin
                next_state = idle_right;
            end
        end
        fall_left: begin
            if (ground) begin
                next_state = idle_left;
            end else begin
                next_state = fall_left;
            end
        end
        fall_right: begin
            if (ground) begin
                next_state = idle_right;
            end else begin
                next_state = fall_right;
            end
        end
        default: next_state = idle_left;
    endcase
end

// Sequential logic for state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= idle_left;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == idle_left) || (state == fall_left);
assign walk_right = (state == idle_right) || (state == fall_right);
assign aaah = (state == fall_left) || (state == fall_right);

endmodule