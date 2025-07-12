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
    parameter WALK = 2'd0;
    parameter FALL = 2'd1;
    parameter DIG  = 2'd2;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right

    // State and direction update with optimized priority handling
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // start left
        end else begin
            case (state)
                WALK: begin
                    // Priority: fall > dig > bump
                    if (!ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else begin
                        // Only change direction when walking on ground
                        case ({bump_left, bump_right})
                            2'b10: direction <= 1'b1; // switch to right
                            2'b01: direction <= 1'b0; // switch to left
                            2'b11: direction <= ~direction; // toggle if both bumps
                            default: ; // maintain direction
                        endcase
                    end
                end
                
                FALL: if (ground) state <= WALK;
                DIG:  if (!ground) state <= FALL;
            endcase
        end
    end

    // Output logic - optimized for clarity and power
    assign walk_left  = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule