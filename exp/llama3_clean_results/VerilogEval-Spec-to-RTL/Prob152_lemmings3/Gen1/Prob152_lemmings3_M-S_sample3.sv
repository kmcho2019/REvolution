module TopModule (
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    input         dig,
    output        walk_left,
    output        walk_right,
    output        aaah,
    output        digging
);

// Enum for the states
enum logic [1:0] {IDLE, FALLING, DIGGING} state, next_state;

// Signal to keep track of the direction the Lemming was walking before it fell or started digging
logic walking_left;

// Initialize the state and walking_left signals
initial begin
    state = IDLE;
    walking_left = 1'b1;
end

// Combinational logic for the next state
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                walking_left = 1'b0;
            end else if (bump_left) begin
                walking_left = 1'b1;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = IDLE;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for the state and walking_left signals
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walking_left <= 1'b1;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == IDLE && walking_left);
assign walk_right = (state == IDLE &&!walking_left);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule