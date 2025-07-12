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

    reg [1:0] state;
    reg direction;  // 0: left, 1: right
    reg [4:0] fall_counter;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // start walking left
            fall_counter <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left || bump_right) begin
                        // Switch direction if bumped on either side
                        direction <= bump_left ? 1'b1 : 1'b0;
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end
                    // Stay in DIG until ground=0
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= WALK;
                        end
                        fall_counter <= 0;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in SPLAT state forever
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction & ~(state == SPLAT);
    assign walk_right = (state == WALK) & direction & ~(state == SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule