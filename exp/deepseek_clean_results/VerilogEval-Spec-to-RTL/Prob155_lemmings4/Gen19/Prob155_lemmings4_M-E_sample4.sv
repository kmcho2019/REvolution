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

    // State encoding
    parameter WALK = 2'b00;
    parameter DIG  = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;

    // Direction encoding
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    reg [1:0] state;
    reg direction;
    reg [4:0] fall_timer;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else if ((direction == LEFT && bump_left) || 
                               (direction == RIGHT && bump_right)) begin
                        direction <= ~direction;
                    end
                end

                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                    end else if (!dig) begin
                        state <= WALK;
                    end
                end

                FALL: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= WALK;
                    end
                end

                SPLAT: state <= SPLAT;
            endcase
        end
    end

    // Fall timer logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_timer <= 0;
        end else begin
            if (state == FALL) begin
                if (!ground)
                    fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) && (direction == LEFT) && !digging;
    assign walk_right = (state == WALK) && (direction == RIGHT) && !digging;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule