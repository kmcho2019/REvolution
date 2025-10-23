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

    // Combined state and direction encoding
    reg [2:0] state;
    reg [4:0] fall_timer;

    // State definitions
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam FALL       = 3'b010;
    localparam DIG        = 3'b011;
    localparam SPLATTER   = 3'b100;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 0;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 0;
                    end else if (dig) begin
                        state <= DIG;
                    end else if ((state == WALK_LEFT && bump_left) || 
                               (state == WALK_RIGHT && bump_right)) begin
                        state <= (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end
                end

                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 0;
                    end
                end

                FALL: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLATTER;
                        else
                            state <= (fall_timer == 0) ? state : 
                                   (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end

                SPLATTER: begin
                    // Stay in splatter state
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule