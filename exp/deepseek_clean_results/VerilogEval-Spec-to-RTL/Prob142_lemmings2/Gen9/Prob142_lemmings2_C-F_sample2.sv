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

    // State definitions for clarity
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state;
    reg direction;  // 0=left, 1=right

    // Combined state and direction update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end
        else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                    else if ((!direction && bump_left) || (direction && bump_right)) begin
                        direction <= ~direction;
                    end
                end
                FALL: begin
                    if (ground) begin
                        state <= WALK;
                    end
                end
            endcase
        end
    end

    // Output logic - direct from registers
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule