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

    parameter WALK_LEFT = 0;
    parameter WALK_RIGHT = 1;
    parameter DIG_LEFT = 2;
    parameter DIG_RIGHT = 3;
    parameter FALL_LEFT = 4;
    parameter FALL_RIGHT = 5;
    parameter SPLAT = 6;

    reg [2:0] state;
    reg [4:0] fall_count;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALL_LEFT;
                    fall_count <= 0;
                end else if (dig) begin
                    state <= DIG_LEFT;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;  // Already walking left
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALL_RIGHT;
                    fall_count <= 0;
                end else if (dig) begin
                    state <= DIG_RIGHT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;  // Already walking right
                end
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    state <= (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    fall_count <= 0;
                end else if (!dig) begin
                    state <= (state == DIG_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (!ground) begin
                    fall_count <= fall_count + 1;
                end else begin
                    if (fall_count > 20) begin
                        state <= SPLAT;
                    end else begin
                        state <= (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end
                end
            end
            
            SPLAT: state <= SPLAT;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule