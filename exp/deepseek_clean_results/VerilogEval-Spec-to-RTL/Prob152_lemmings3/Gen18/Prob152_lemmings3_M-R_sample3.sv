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

    // One-hot state encoding
    parameter WALK = 2'b01;
    parameter FALL = 2'b10;
    parameter DIG  = 2'b00; // Not actually one-hot, but works for 3 states
    
    reg [1:0] state;
    reg direction; // 0=left, 1=right
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (state)
                WALK: begin
                    if (~ground)       state <= FALL;
                    else if (dig)     state <= DIG;
                    else              state <= WALK;
                end
                FALL: begin
                    if (ground)       state <= WALK;
                    else             state <= FALL;
                end
                DIG: begin
                    if (~ground)      state <= FALL;
                    else              state <= DIG;
                end
            endcase
        end
    end
    
    // Direction logic (only changes in WALK state)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end else if (state == WALK) begin
            case ({bump_left, bump_right})
                2'b01: direction <= 1'b0; // bump_right -> walk left
                2'b10: direction <= 1'b1; // bump_left -> walk right
                2'b11: direction <= ~direction; // both bumps -> toggle
                default: direction <= direction; // no change
            endcase
        end
    end
    
    // Output assignments
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule