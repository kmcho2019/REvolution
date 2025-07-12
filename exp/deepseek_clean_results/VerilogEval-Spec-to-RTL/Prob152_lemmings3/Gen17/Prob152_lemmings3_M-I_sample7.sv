module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // States
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right

    // Parallel state transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else if (dig) begin
                    next_state = DIG;
                end
                else if ((bump_left && !direction) || (bump_right && direction)) begin
                    next_direction = ~direction; // Only toggle if needed
                end
            end
            
            FALL: if (ground) next_state = WALK;
            
            DIG: if (!ground) next_state = FALL;
            
            default: next_state = WALK; // Handle unused state
        endcase
    end

    // Sequential logic with registered outputs
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        else begin
            state <= next_state;
            direction <= next_direction;
            
            // Registered outputs
            walk_left <= (next_state == WALK) & ~next_direction;
            walk_right <= (next_state == WALK) & next_direction;
            aaah <= (next_state == FALL);
            digging <= (next_state == DIG);
        end
    end

endmodule