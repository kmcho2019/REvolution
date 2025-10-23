module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define states
localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;

// Combinational logic to determine next state
always @(*) begin
    case(current_state)
        IDLE_LEFT: begin
            if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT; // No change
            end else begin
                next_state = IDLE_LEFT; // No change
            end
        end
        IDLE_RIGHT: begin
            if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT; // No change
            end else begin
                next_state = IDLE_RIGHT; // No change
            end
        end
        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
    if (bump_left && bump_right) begin
        case(current_state)
            IDLE_LEFT: next_state = IDLE_RIGHT;
            IDLE_RIGHT: next_state = IDLE_LEFT;
            default: next_state = IDLE_LEFT;
        endcase
    end
end

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        current_state <= next_state;
        case(next_state)
            IDLE_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            IDLE_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            default: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
        endcase
    end
end

endmodule