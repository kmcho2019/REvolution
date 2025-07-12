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
    reg direction;  // 0=left, 1=right
    reg last_bump_left, last_bump_right;

    // Filter bump signals to prevent unnecessary toggles
    always @(posedge clk) begin
        last_bump_left <= bump_left;
        last_bump_right <= bump_right;
    end

    wire real_bump_left = bump_left && !last_bump_left;
    wire real_bump_right = bump_right && !last_bump_right;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end
                end
                
                FALL: begin
                    if (ground) state <= WALK;
                end
                
                DIG: begin
                    if (!ground) state <= FALL;
                end
            endcase
        end
    end

    // Direction update with clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end else if (state == WALK && ground && !dig) begin
            if (real_bump_left && !direction) begin
                direction <= 1;
            end else if (real_bump_right && direction) begin
                direction <= 0;
            end
        end
    end

    // Registered outputs
    always @(posedge clk) begin
        walk_left <= (state == WALK) && !direction;
        walk_right <= (state == WALK) && direction;
        aaah <= (state == FALL);
        digging <= (state == DIG);
    end

endmodule