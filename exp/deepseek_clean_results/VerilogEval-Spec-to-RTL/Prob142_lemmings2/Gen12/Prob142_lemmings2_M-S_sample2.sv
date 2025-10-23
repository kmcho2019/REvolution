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

    // States
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state;
    reg direction;  // 0=left, 1=right
    
    // Next state and direction logic
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
                    else if ((direction && bump_right) || (!direction && bump_left)) begin
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
    
    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule