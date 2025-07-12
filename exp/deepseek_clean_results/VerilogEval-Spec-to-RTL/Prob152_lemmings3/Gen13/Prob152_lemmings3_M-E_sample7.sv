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

    // Primary states (physical state)
    localparam WALK = 3'b001;
    localparam FALL = 3'b010;
    localparam DIG  = 3'b100;
    reg [2:0] phys_state;

    // Secondary states (direction)
    localparam LEFT  = 2'b01;
    localparam RIGHT = 2'b10;
    reg [1:0] dir_state;

    // Edge detection and flags
    reg ground_prev;
    reg just_landed;
    reg pending_dir_change;

    // Edge detection for ground
    always @(posedge clk) begin
        ground_prev <= ground;
    end

    // Primary state machine
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            phys_state <= WALK;
            just_landed <= 0;
        end else begin
            case (phys_state)
                WALK: begin
                    if (!ground) begin
                        phys_state <= FALL;
                        just_landed <= 0;
                    end else if (dig) begin
                        phys_state <= DIG;
                        just_landed <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        phys_state <= WALK;
                        just_landed <= 1;
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        phys_state <= FALL;
                        just_landed <= 0;
                    end
                end
            endcase
            
            // Clear just_landed after one cycle
            if (just_landed && phys_state == WALK) begin
                just_landed <= 0;
            end
        end
    end

    // Direction state machine
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir_state <= LEFT;
            pending_dir_change <= 0;
        end else begin
            // Handle pending direction changes
            if (pending_dir_change && phys_state == WALK && ground && !just_landed) begin
                dir_state <= (dir_state == LEFT) ? RIGHT : LEFT;
                pending_dir_change <= 0;
            end
            
            // Process bumps (only when walking on ground)
            if (phys_state == WALK && ground && !just_landed) begin
                if (bump_left || bump_right) begin
                    pending_dir_change <= 1;
                end
            end
        end
    end

    // Output logic
    assign walk_left  = (phys_state == WALK) && (dir_state == LEFT);
    assign walk_right = (phys_state == WALK) && (dir_state == RIGHT);
    assign aaah       = (phys_state == FALL);
    assign digging    = (phys_state == DIG);

endmodule