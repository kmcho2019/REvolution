module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Enumerate the states
typedef enum logic [1:0] {
    STATE_WALK_LEFT = 2'b00,
    STATE_WALK_RIGHT = 2'b01
} state_t;

// Declare the state register
reg [1:0] state;
reg [1:0] next_state;

// Declare the output wires
wire walk_left_wire;
wire walk_right_wire;

// Assign the outputs based on the current state
assign walk_left_wire = (state == STATE_WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right_wire = (state == STATE_WALK_RIGHT) ? 1'b1 : 1'b0;

// Assign the outputs to the output ports
assign walk_left = walk_left_wire;
assign walk_right = walk_right_wire;

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        STATE_WALK_LEFT: begin
            if (bump_left) begin
                next_state <= STATE_WALK_RIGHT;
            end else begin
                next_state <= STATE_WALK_LEFT;
            end
        end
        STATE_WALK_RIGHT: begin
            if (bump_right) begin
                next_state <= STATE_WALK_LEFT;
            end else begin
                next_state <= STATE_WALK_RIGHT;
            end
        end
        default: begin
            next_state <= STATE_WALK_LEFT;
        end
    endcase
    
    // If both bump_left and bump_right are high, switch directions
    if (bump_left && bump_right) begin
        if (state == STATE_WALK_LEFT) begin
            next_state <= STATE_WALK_RIGHT;
        end else begin
            next_state <= STATE_WALK_LEFT;
        end
    end
end

endmodule