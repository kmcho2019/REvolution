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

    // States
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;

    reg state;
    reg direction; // 0=left, 1=right
    reg dig_active;

    // Clock gating for dig_active
    wire dig_clk_en = dig || (state == FALL) || areset;
    wire gated_clk = dig_clk_en ? clk : 1'b0;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end
        else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                end
                else if (!dig_active && (bump_left || bump_right)) begin
                    direction <= bump_left;
                end
            end
            
            FALL: if (ground) begin
                state <= WALK;
            end
        endcase
    end

    // Dig_active register with clock gating
    always @(posedge gated_clk, posedge areset) begin
        if (areset) begin
            dig_active <= 0;
        end
        else if (state == WALK) begin
            dig_active <= dig && ground;
        end
        else begin
            dig_active <= 0;
        end
    end

    // Shared output logic
    wire walking = (state == WALK) & ~dig_active;
    assign walk_left  = walking & ~direction;
    assign walk_right = walking & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == WALK) & dig_active;

endmodule