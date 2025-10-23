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
    
    // State and direction update with power optimization
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end
        else begin
            // State transition
            case (state)
                WALK: state <= ground ? WALK : FALL;
                FALL: state <= ground ? WALK : FALL;
            endcase
            
            // Direction update (only when walking and ground is present)
            if (state == WALK && ground) begin
                if ((direction && bump_right) || (!direction && bump_left))
                    direction <= ~direction;
            end
        end
    end
    
    // Output logic - Moore style
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule