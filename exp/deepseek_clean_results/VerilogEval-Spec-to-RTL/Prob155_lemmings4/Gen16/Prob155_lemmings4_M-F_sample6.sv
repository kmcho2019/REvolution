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

    // Movement direction (persistent between states)
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    reg movement_dir;

    // Main action states
    parameter WALK = 2'b00;
    parameter DIG  = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;
    reg [1:0] state;

    // Fall duration counter
    reg [4:0] fall_cycles;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            movement_dir <= LEFT;
            fall_cycles <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left || bump_right) begin
                        // Switch direction (right if both)
                        movement_dir <= bump_left ? RIGHT : LEFT;
                    end
                end

                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_cycles <= 1;
                    end
                end

                FALL: begin
                    if (ground) begin
                        if (fall_cycles > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= WALK;
                        end
                        fall_cycles <= 0;
                    end else begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end

                SPLAT: begin
                    // Permanent state
                end
            endcase
        end
    end

    // Output generation (Moore style - based only on current state)
    assign walk_left = (state == WALK) && (movement_dir == LEFT) && (state != SPLAT);
    assign walk_right = (state == WALK) && (movement_dir == RIGHT) && (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule