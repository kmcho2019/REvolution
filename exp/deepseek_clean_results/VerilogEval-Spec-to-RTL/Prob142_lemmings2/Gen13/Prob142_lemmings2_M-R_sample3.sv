module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State definitions
    localparam WALK = 1'b0;
    localparam FALL = 1'b1;
    
    reg state;      // Current state (WALK or FALL)
    reg direction;  // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            case (state)
                WALK: state <= ground ? WALK : FALL;
                FALL: state <= ground ? WALK : FALL;
            endcase
        end
    end

    // Direction update logic (only in WALK state)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Start walking left
        end
        else if (state == WALK && ground) begin
            if ((!direction && bump_left) || (direction && bump_right))
                direction <= ~direction;
        end
    end

    // Output assignments
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule