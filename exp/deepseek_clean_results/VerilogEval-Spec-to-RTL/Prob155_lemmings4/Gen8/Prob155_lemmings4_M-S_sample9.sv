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
    reg [1:0] state;
    localparam WALK_L = 2'b00,
               WALK_R = 2'b01,
               FALL   = 2'b10,
               DIG    = 2'b11;

    reg [4:0] fall_counter;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK_L, WALK_R: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else begin
                        // Handle bumps only if not falling/digging
                        if (bump_left && state == WALK_L) state <= WALK_R;
                        if (bump_right && state == WALK_R) state <= WALK_L;
                    end
                end
                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20)
                            state <= 2'b00; // Splatter (all outputs 0)
                        else
                            state <= (fall_counter[0]) ? WALK_R : WALK_L; // Resume previous direction
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule