module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter STATE_LEFT = 0;
parameter STATE_RIGHT = 1;

// Define current and next states
reg [0:0] current_state;
reg [0:0] next_state;

// Assign initial state
initial begin
    current_state = STATE_LEFT;
end

// Next state logic
always @(*) begin
    case(current_state)
        STATE_LEFT: begin
            if(bump_left) begin
                next_state = STATE_RIGHT;
            end else begin
                next_state = STATE_LEFT;
            end
        end
        STATE_RIGHT: begin
            if(bump_right) begin
                next_state = STATE_LEFT;
            end else begin
                next_state = STATE_RIGHT;
            end
        end
    endcase

    // Handle the case when both bump_left and bump_right are high
    if(bump_left && bump_right) begin
        case(current_state)
            STATE_LEFT: begin
                next_state = STATE_RIGHT;
            end
            STATE_RIGHT: begin
                next_state = STATE_LEFT;
            end
        endcase
    end
end

// State update logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= STATE_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(current_state)
        STATE_LEFT: begin
            walk_left = 1;
            walk_right = 0;
        end
        STATE_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
        end
    endcase
end

endmodule