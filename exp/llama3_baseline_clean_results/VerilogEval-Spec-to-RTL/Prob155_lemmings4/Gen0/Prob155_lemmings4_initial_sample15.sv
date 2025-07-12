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

// State machine states
parameter WALK_LEFT = 4'd0;
parameter WALK_RIGHT = 4'd1;
parameter FALLING = 4'd2;
parameter DIGGING = 4'd3;
parameter SPLATTERED = 4'd4;

// Current state
reg [3:0] state;
reg [3:0] next_state;

// Counter for falling
reg [5:0] fall_count;
reg [5:0] next_fall_count;

// Previous ground state and dig state
reg prev_ground;
reg prev_dig;

// Initialize the state machine
initial begin
    state = WALK_LEFT;
    fall_count = 0;
    prev_ground = 1'b1;
    prev_dig = 1'b0;
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
        prev_ground <= 1'b1;
        prev_dig <= 1'b0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
        prev_ground <= ground;
        prev_dig <= dig;
    end
end

// Combinational logic
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    next_state = state;
    next_fall_count = fall_count;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
        end

        FALLING: begin
            aaah = 1'b1;
            next_fall_count = fall_count + 1;
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
        end

        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end

        SPLATTERED: begin
            // Do nothing
        end

        default: begin
            // Do nothing
        end
    endcase
end

endmodule