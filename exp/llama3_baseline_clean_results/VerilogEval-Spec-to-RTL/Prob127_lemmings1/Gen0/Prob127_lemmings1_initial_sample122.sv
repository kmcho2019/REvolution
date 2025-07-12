module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    output          walk_left,
    output          walk_right
);

// Define the states
localparam [1:0] WALK_LEFT = 2'b00;
localparam [1:0] WALK_RIGHT = 2'b01;

reg [1:0] current_state;
reg [1:0] next_state;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        default: begin
            next_state <= WALK_LEFT;
        end
    endcase
    
    // If both bump signals are high, switch direction
    if (bump_left && bump_right) begin
        case (current_state)
            WALK_LEFT: next_state <= WALK_RIGHT;
            WALK_RIGHT: next_state <= WALK_LEFT;
            default: next_state <= WALK_LEFT;
        endcase
    end
end

// Output logic
always @(*) begin
    case (current_state)
        WALK_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
        default: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
    endcase
end

endmodule