module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states using a one-hot encoding
reg [1:0] state;
localparam IDLE_LEFT = 2'b01;
localparam IDLE_RIGHT = 2'b10;
localparam FALLING_LEFT = 2'b00;
localparam FALLING_RIGHT = 2'b11;

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        case(state)
            IDLE_LEFT: begin
                if (~ground) begin
                    state <= FALLING_LEFT;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                end else if (bump_right) begin
                    // No change in state when bumped right while walking left
                end else if (bump_left && bump_right) begin
                    state <= IDLE_RIGHT;
                end
            end
            IDLE_RIGHT: begin
                if (~ground) begin
                    state <= FALLING_RIGHT;
                end else if (bump_left) begin
                    state <= IDLE_LEFT;
                end else if (bump_right) begin
                    // No change in state when bumped right while walking right
                end else if (bump_left && bump_right) begin
                    state <= IDLE_LEFT;
                end
            end
            FALLING_LEFT: begin
                if (ground) begin
                    state <= IDLE_LEFT;
                end
            end
            FALLING_RIGHT: begin
                if (ground) begin
                    state <= IDLE_RIGHT;
                end
            end
            default: begin
                // Handle invalid states
                state <= IDLE_LEFT;
            end
        endcase
    end
end

// Generate output signals directly within the state machine logic
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        FALLING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            // Handle invalid states
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule