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

// Define states
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

reg [4:0] fall_counter;
reg walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 1'b0; // Initial walk direction is left
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        fall_counter <= (state == FALLING)? (ground? 5'b0 : fall_counter + 1'b1) : fall_counter;
        if (state == WALKING && (bump_left || bump_right)) begin
            walk_direction <= ~walk_direction;
        end
    end
end

// Next state logic
always_comb begin
    case (state)
        WALKING: next_state = (~ground)? FALLING : (dig && ground)? DIGGING : WALKING;
        FALLING: next_state = (ground && fall_counter > 5'd20)? SPLATTERED : (ground)? WALKING : FALLING;
        DIGGING: next_state = (~ground)? FALLING : DIGGING;
        SPLATTERED: next_state = SPLATTERED;
    endcase
end

// Output assignments
assign walk_left = (state == WALKING)? ~walk_direction : 1'b0;
assign walk_right = (state == WALKING)? walk_direction : 1'b0;
assign aaah = (state == FALLING)? 1'b1 : 1'b0;
assign digging = (state == DIGGING)? 1'b1 : 1'b0;

endmodule