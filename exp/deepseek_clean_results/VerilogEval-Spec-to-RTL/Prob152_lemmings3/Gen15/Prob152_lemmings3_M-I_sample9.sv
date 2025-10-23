module TopModule (
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

    // States with binary encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [3:0] outputs; // Registered outputs: {walk_left, walk_right, aaah, digging}

    // State and direction update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            outputs <= 4'b1000; // walk_left=1, others=0
        end
        else begin
            state <= next_state;
            direction <= next_direction;
            outputs <= {next_state == WALK & ~next_direction,
                        next_state == WALK & next_direction,
                        next_state == FALL,
                        next_state == DIG};
        end
    end

    // Next state and direction logic
    always @(*) begin
        // Default assignments
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
                else if (bump_left || bump_right) begin
                    next_direction = bump_left;
                end
            end
            
            FALL: if (ground) next_state = WALK;
            
            DIG: if (!ground) next_state = FALL;
        endcase
    end

    // Output assignments
    assign {walk_left, walk_right, aaah, digging} = outputs;

endmodule