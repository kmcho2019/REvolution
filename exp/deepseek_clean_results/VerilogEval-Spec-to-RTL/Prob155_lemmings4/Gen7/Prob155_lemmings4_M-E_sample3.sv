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

    // Direction states (one-hot)
    localparam DIR_LEFT = 1'b0;
    localparam DIR_RIGHT = 1'b1;
    reg direction;  // Current direction
    
    // Action states (one-hot)
    localparam [3:0]
        WALK  = 4'b0001,
        FALL  = 4'b0010,
        DIG   = 4'b0100,
        SPLAT = 4'b1000;
    reg [3:0] action, next_action;
    
    // Edge detection for ground signal
    reg ground_prev;
    wire ground_falling = ground_prev & ~ground;
    wire ground_rising = ~ground_prev & ground;
    
    // Edge detection for dig signal
    reg dig_prev;
    wire dig_rising = ~dig_prev & dig;
    
    // Fall timer module
    wire [4:0] fall_count;
    FallTimer fall_timer (
        .clk(clk),
        .reset(areset | (action != FALL)),
        .enable(~ground & (action == FALL)),
        .count(fall_count)
    );
    
    // Synchronous logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action <= WALK;
            direction <= DIR_LEFT;
            ground_prev <= 1'b1;
            dig_prev <= 1'b0;
        end else begin
            action <= next_action;
            
            // Update direction only when walking and not falling
            if (action == WALK && ground) begin
                case ({bump_left, bump_right})
                    2'b10: direction <= DIR_RIGHT;
                    2'b01: direction <= DIR_LEFT;
                    default: direction <= direction;
                endcase
            end
            
            ground_prev <= ground;
            dig_prev <= dig;
        end
    end
    
    // Next action logic
    always @(*) begin
        case (action)
            SPLAT: next_action = SPLAT;
            
            WALK: begin
                if (ground_falling)
                    next_action = FALL;
                else if (dig_rising && ground)
                    next_action = DIG;
                else
                    next_action = WALK;
            end
            
            FALL: begin
                if (ground_rising) begin
                    next_action = (fall_count > 20) ? SPLAT : WALK;
                end else begin
                    next_action = FALL;
                end
            end
            
            DIG: begin
                if (~ground)
                    next_action = FALL;
                else
                    next_action = DIG;
            end
            
            default: next_action = WALK;
        endcase
    end
    
    // Output logic
    assign walk_left = (action == WALK) && (direction == DIR_LEFT);
    assign walk_right = (action == WALK) && (direction == DIR_RIGHT);
    assign aaah = (action == FALL);
    assign digging = (action == DIG);
    
endmodule

// Submodule for fall timer
module FallTimer (
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule