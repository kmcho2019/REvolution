module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define the states
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Define the current state
reg current_state;

// Handle asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        // State transition logic
        case (current_state)
            WALK_LEFT: 
                if (bump_left) begin
                    current_state <= WALK_RIGHT;
                end else begin
                    current_state <= WALK_LEFT;
                end
            WALK_RIGHT: 
                if (bump_right) begin
                    current_state <= WALK_LEFT;
                end else begin
                    current_state <= WALK_RIGHT;
                end
            default: current_state <= WALK_LEFT;
        endcase
    end
end

// Output logic
always @(posedge clk) begin
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