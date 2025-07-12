module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
reg [1:0] next_state;

// Define the states
parameter WALK_LEFT = 2'b01;
parameter WALK_RIGHT = 2'b10;

// Initialize the state machine
initial begin
    state = WALK_LEFT;
end

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = state;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = state;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule