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

    // States
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    reg [1:0] state, next_state;

    // Direction
    reg direction, next_direction; // 0=left, 1=right
    
    // Fall counter
    reg [4:0] fall_cycles, next_fall_cycles;

    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        next_fall_cycles = fall_cycles;
        
        if (state == SPLAT) begin
            // Stay in SPLAT state forever
            next_state = SPLAT;
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        next_state = FALL;
                        next_fall_cycles = 1;
                    end else if (dig) begin
                        next_state = DIG;
                    end else if (bump_left || bump_right) begin
                        next_direction = bump_left ? 1 : 0;
                    end
                end
                
                DIG: begin
                    if (~ground) begin
                        next_state = FALL;
                        next_fall_cycles = 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_cycles > 20) begin
                            next_state = SPLAT;
                        end else begin
                            next_state = WALK;
                        end
                        next_fall_cycles = 0;
                    end else begin
                        next_fall_cycles = fall_cycles + 1;
                    end
                end
                
                default: next_state = WALK;
            endcase
        end
    end

    // State register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_cycles <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_cycles <= next_fall_cycles;
        end
    end

    // Outputs
    assign walk_left = (state == WALK) && ~direction && (state != SPLAT);
    assign walk_right = (state == WALK) && direction && (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule