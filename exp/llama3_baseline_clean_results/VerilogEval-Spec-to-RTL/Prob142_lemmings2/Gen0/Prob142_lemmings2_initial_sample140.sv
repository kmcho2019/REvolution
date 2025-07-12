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

// Define the states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;

// State variable
reg [1:0] state;
reg [1:0] nextState;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= nextState;
    end
end

// Combinational logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if(~ground) begin
                nextState <= FALLING;
            end else if(bump_left) begin
                nextState <= WALK_RIGHT;
            end else begin
                nextState <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if(~ground) begin
                nextState <= FALLING;
            end else if(bump_right) begin
                nextState <= WALK_LEFT;
            end else begin
                nextState <= WALK_RIGHT;
            end
        end
        FALLING: begin
            if(ground) begin
                // Go back to previous state
                if(bump_left && bump_right) begin
                    // Switch direction
                    if(nextState == WALK_LEFT) begin
                        nextState <= WALK_RIGHT;
                    end else if(nextState == WALK_RIGHT) begin
                        nextState <= WALK_LEFT;
                    end else begin
                        nextState <= WALK_LEFT; // Default
                    end
                end else if(bump_left) begin
                    nextState <= WALK_RIGHT;
                end else if(bump_right) begin
                    nextState <= WALK_LEFT;
                end else begin
                    // Maintain previous direction
                    if(nextState == WALK_LEFT) begin
                        nextState <= WALK_LEFT;
                    end else if(nextState == WALK_RIGHT) begin
                        nextState <= WALK_RIGHT;
                    end else begin
                        nextState <= WALK_LEFT; // Default
                    end
                end
            end else begin
                nextState <= FALLING;
            end
        end
        default: begin
            nextState <= WALK_LEFT;
        end
    endcase
end

// Output logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end
        WALK_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
        end
        FALLING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
        end
        default: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
        end
    endcase
end

endmodule