module TopModule(
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    output        walk_left,
    output        walk_right
);

reg [0:0] current_state;
reg [0:0] next_state;

// Define the states
localparam WALK_LEFT = 0;
localparam WALK_RIGHT = 1;

// Combinational logic to determine the next state
always @(*) begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
    
    // Handle both bump_left and bump_right being asserted
    if (bump_left && bump_right) begin
        case (current_state)
            WALK_LEFT: next_state = WALK_RIGHT;
            WALK_RIGHT: next_state = WALK_LEFT;
        endcase
    end
end

// Sequential logic to update the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign walk_left = (current_state == WALK_LEFT);
assign walk_right = (current_state == WALK_RIGHT);

endmodule