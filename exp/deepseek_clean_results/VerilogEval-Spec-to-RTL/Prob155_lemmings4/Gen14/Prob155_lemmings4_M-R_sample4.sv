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

    // Unified state encoding
    localparam LEFT  = 3'b000;
    localparam RIGHT = 3'b001;
    localparam FALL_L = 3'b010;
    localparam FALL_R = 3'b011;
    localparam DIG_L = 3'b100;
    localparam DIG_R = 3'b101;
    localparam SPLAT = 3'b110;
    
    reg [2:0] state;
    reg [4:0] fall_timer;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_timer <= 0;
        end else begin
            case (state)
                LEFT: begin
                    if (~ground) begin
                        state <= FALL_L;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DIG_L;
                    end else if (bump_left) begin
                        state <= RIGHT;
                    end
                end
                
                RIGHT: begin
                    if (~ground) begin
                        state <= FALL_R;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DIG_R;
                    end else if (bump_right) begin
                        state <= LEFT;
                    end
                end
                
                FALL_L, FALL_R: begin
                    if (ground) begin
                        state <= (fall_timer > 20) ? SPLAT : 
                               (state == FALL_L) ? LEFT : RIGHT;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                DIG_L: begin
                    if (~ground) begin
                        state <= FALL_L;
                        fall_timer <= 1;
                    end
                end
                
                DIG_R: begin
                    if (~ground) begin
                        state <= FALL_R;
                        fall_timer <= 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in splatter state forever
                end
            endcase
        end
    end

    // Output logic - direct assignments from state
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign digging = (state == DIG_L) || (state == DIG_R);

endmodule