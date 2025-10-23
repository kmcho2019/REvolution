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

// Define states
parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;
parameter SPLATTERED = 3'b111;

// State variable
reg [2:0] state;
reg [2:0] next_state;

// Counter for falling clock cycles
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Default assignments
assign walk_left = 1'b0;
assign walk_right = 1'b0;
assign aaah = 1'b0;
assign digging = 1'b0;

// Output logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING: begin
            digging = 1'b1;
        end
        SPLATTERED: begin
            // Do nothing
        end
        default: begin
            // Do nothing
        end
    endcase
end

// Next state logic
always @(*) begin
    next_state = state;
    next_fall_counter = fall_counter;
    
    case(state)
        WALK_LEFT: begin
            if(bump_left) begin
                next_state = WALK_RIGHT;
            end else if(bump_right) begin
                next_state = WALK_LEFT; // Do nothing
            end else if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            if(bump_left) begin
                next_state = WALK_LEFT;
            end else if(bump_right) begin
                next_state = WALK_LEFT; // Switch direction
            end else if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if(ground) begin
                if(fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if(state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else if(state == WALK_RIGHT) begin
                        next_state = WALK_RIGHT;
                    end else if(state == DIGGING) begin
                        next_state = WALK_LEFT; // Assume initial direction is left
                    end
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        DIGGING: begin
            if(!ground) begin
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

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'b0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

endmodule