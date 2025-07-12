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

    // Direction states
    localparam DIR_LEFT = 1'b0;
    localparam DIR_RIGHT = 1'b1;
    reg direction;

    // Action states
    localparam [1:0]
        WALK  = 2'b00,
        FALL  = 2'b01,
        DIG   = 2'b10,
        SPLAT = 2'b11;
    reg [1:0] action;

    reg [4:0] fall_counter;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
            action <= WALK;
            fall_counter <= 0;
        end else begin
            // Fall counter logic
            if (action == FALL && !ground) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end

            // Action state transitions
            case (action)
                WALK: begin
                    if (!ground) begin
                        action <= FALL;
                    end else if (dig) begin
                        action <= DIG;
                    end else if ((direction == DIR_LEFT && bump_left) || 
                                (direction == DIR_RIGHT && bump_right)) begin
                        direction <= ~direction;
                    end
                end

                FALL: begin
                    if (ground) begin
                        action <= (fall_counter > 20) ? SPLAT : WALK;
                    end
                end

                DIG: begin
                    if (!ground) begin
                        action <= FALL;
                    end
                end

                SPLAT: begin
                    // Stay in SPLAT forever
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (action == WALK || action == DIG) && (direction == DIR_LEFT);
    assign walk_right = (action == WALK || action == DIG) && (direction == DIR_RIGHT);
    assign aaah = (action == FALL);
    assign digging = (action == DIG);

endmodule