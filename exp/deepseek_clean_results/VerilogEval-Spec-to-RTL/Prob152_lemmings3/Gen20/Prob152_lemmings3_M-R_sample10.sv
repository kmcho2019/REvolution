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

    // One-hot state encoding
    parameter WALK_L = 2'b00;
    parameter WALK_R = 2'b01;
    parameter FALL   = 2'b10;
    parameter DIG    = 2'b11;

    reg [1:0] state;
    reg direction; // 0=left, 1=right

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
        end
        else begin
            case (state)
                WALK_L, WALK_R: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                    else if (dig) begin
                        state <= DIG;
                    end
                    else if (bump_left || bump_right) begin
                        state <= bump_left ? WALK_R : WALK_L;
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                    else if (!dig) begin
                        state <= direction ? WALK_R : WALK_L;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= direction ? WALK_R : WALK_L;
                    end
                end
            endcase
        end
    end

    // Direction tracking (separate for clarity)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (state == WALK_L || state == WALK_R) begin
            if (bump_left) direction <= 1;
            else if (bump_right) direction <= 0;
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule