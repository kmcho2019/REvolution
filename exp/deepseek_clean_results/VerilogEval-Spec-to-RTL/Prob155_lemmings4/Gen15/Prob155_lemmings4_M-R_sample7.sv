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
    reg direction;  // 0=left, 1=right

    // Action states
    localparam ACT_WALK = 2'b00;
    localparam ACT_FALL = 2'b01;
    localparam ACT_DIG  = 2'b10;
    localparam ACT_SPLAT = 2'b11;
    reg [1:0] action;

    // Fall timer
    reg [4:0] fall_timer;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
            action <= ACT_WALK;
            fall_timer <= 0;
        end else begin
            case (action)
                ACT_WALK: begin
                    if (~ground) begin
                        action <= ACT_FALL;
                        fall_timer <= 1;
                    end else if (dig) begin
                        action <= ACT_DIG;
                    end else if ((direction == DIR_LEFT && bump_left) || 
                                (direction == DIR_RIGHT && bump_right)) begin
                        direction <= ~direction;
                    end
                end

                ACT_FALL: begin
                    if (ground) begin
                        if (fall_timer > 20) begin
                            action <= ACT_SPLAT;
                        end else begin
                            action <= ACT_WALK;
                        end
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end

                ACT_DIG: begin
                    if (~ground) begin
                        action <= ACT_FALL;
                        fall_timer <= 1;
                    end else if (~dig) begin
                        action <= ACT_WALK;
                    end
                end

                ACT_SPLAT: begin
                    // Stay in splat state forever
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (action == ACT_WALK) && (direction == DIR_LEFT);
    assign walk_right = (action == ACT_WALK) && (direction == DIR_RIGHT);
    assign aaah = (action == ACT_FALL);
    assign digging = (action == ACT_DIG);

endmodule