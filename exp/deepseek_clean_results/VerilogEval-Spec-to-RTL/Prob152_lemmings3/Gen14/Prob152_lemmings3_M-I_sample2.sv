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

    // One-hot state encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    reg [2:0] state;
    reg direction; // 0=left, 1=right
    reg direction_en; // Clock enable for direction register
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else case (state)
            WALK: begin
                if (!ground)      state <= FALL;
                else if (dig)    state <= DIG;
            end
            FALL: if (ground)    state <= WALK;
            DIG:  if (!ground)   state <= FALL;
            default:              state <= WALK;
        endcase
    end
    
    // Direction changes (clock-gated)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (direction_en) begin
            if (bump_left)        direction <= 1;
            else if (bump_right) direction <= 0;
        end
    end
    
    // Clock gating and output logic
    always @(*) begin
        direction_en = (state == WALK) && ground && !dig;
        
        // Registered outputs
        walk_left  = (state == WALK) && !direction;
        walk_right = (state == WALK) && direction;
        aaah       = (state == FALL);
        digging    = (state == DIG);
    end

endmodule