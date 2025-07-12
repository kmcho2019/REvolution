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
    wire direction_clk_en;
    
    // Clock gating for direction register
    assign direction_clk_en = (state == WALK) && ground && 
                             ((direction && bump_right) || (!direction && bump_left));
    
    // State update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            case (state)
                WALK: state <= (!ground) ? FALL : WALK;
                FALL: state <= (ground) ? WALK : FALL;
            endcase
        end
    end
    
    // Direction update with clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // Start walking left
        end
        else if (direction_clk_en) begin
            direction <= ~direction;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule