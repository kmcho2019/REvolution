module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State encoding
    localparam [1:0]
        S_WALK = 2'b00,
        S_FALL = 2'b01,
        S_DIG  = 2'b10;

    reg [1:0] state;
    reg       dir;          // 0 = left, 1 = right
    reg       prev_ground;  // for synchronous edge detection

    wire bumped = bump_left | bump_right;

    // Update prev_ground every clock cycle (or reset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            prev_ground <= 1'b1; // assume start on ground
        else
            prev_ground <= ground;
    end

    // State transitions (Moore FSM)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK;
        end else begin
            case (state)
                S_WALK: begin
                    // Detect ground falling edge
                    if (prev_ground && !ground) 
                        state <= S_FALL;       // Start falling
                    else if (dig && ground)  
                        state <= S_DIG;        // Start digging
                    else 
                        state <= S_WALK;       // Stay walking
                end
                S_FALL: begin
                    if (!prev_ground && ground) 
                        state <= S_WALK;       // Land and walk
                    else 
                        state <= S_FALL;       // Keep falling
                end
                S_DIG: begin
                    if (!ground) 
                        state <= S_FALL;       // Fall off digging edge
                    else 
                        state <= S_DIG;        // Continue digging
                end
                default: 
                    state <= S_WALK;
            endcase
        end
    end

    // Direction updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0;  // start walking left
        end else begin
            if (state == S_WALK) begin
                // Only change direction on bump while walking and if not falling/digging
                // But bump does not affect direction if falling or digging
                // Also bumps while ground just fell or rose are ignored (already handled by state transitions)
                if (bumped) begin
                    dir <= ~dir;
                end else begin
                    dir <= dir; // hold direction
                end
            end else begin
                // When falling or digging, keep direction unchanged
                dir <= dir;
            end
        end
    end

    // Outputs (Moore)
    assign walk_left  = (state == S_WALK) && (dir == 1'b0);
    assign walk_right = (state == S_WALK) && (dir == 1'b1);
    assign aaah       = (state == S_FALL);
    assign digging    = (state == S_DIG);

endmodule