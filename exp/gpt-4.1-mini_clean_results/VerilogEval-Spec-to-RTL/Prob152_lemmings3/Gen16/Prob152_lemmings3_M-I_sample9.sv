module TopModule(
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

    // State encoding (2 bits)
    localparam WLK_L = 2'b00; // walking left
    localparam WLK_R = 2'b01; // walking right
    localparam DIG_L = 2'b10; // digging left
    localparam DIG_R = 2'b11; // digging right
    // falling is implicitly a separate bit: if falling=1, outputs & transitions accordingly
    // We'll store falling in a separate 1-bit register for clarity and minimal registers: so total 3 bits (mode + falling)
    // This small tradeoff simplifies fall logic.

    reg [1:0] mode;  // walking or digging + direction
    reg falling;     // 0 = on ground (walking or digging), 1 = falling

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WLK_L;
            falling <= 1'b0;
        end else begin
            if (falling) begin
                // Falling: stay falling until ground returns
                if (ground) begin
                    falling <= 1'b0;
                    // Resume walking in previous direction (mode must be walking state)
                    // If was digging before fall, now walking same direction
                    // So force mode to walking, direction preserved from mode bits
                    if (mode == DIG_L)
                        mode <= WLK_L;
                    else if (mode == DIG_R)
                        mode <= WLK_R;
                    // else mode unchanged (already walking)
                    // (In case of fall after walking, mode unchanged)
                end
                // else remain falling
            end else begin
                // Not falling: walking or digging on ground

                if (!ground) begin
                    // ground gone: start falling
                    falling <= 1'b1;
                end else begin
                    // ground present

                    case (mode)
                        WLK_L: begin
                            if (dig) begin
                                mode <= DIG_L; // start digging left
                            end else if (bump_left || (bump_left && bump_right)) begin
                                // bump left flips to walking right
                                mode <= WLK_R;
                            end else if (bump_right) begin
                                mode <= WLK_L; // stay same direction walking left (per spec bump_right bumps walking left -> walk left? No. 
                                // Spec says bump_right => walk left, bump_left => walk right, bump both => flip direction
                                // So bump_right on walking left => walk left (same), no direction change
                                // So this is a no change case. So keep mode WLK_L.
                                // So effectively bump_right does nothing on walking left.
                            end
                            // else no change
                        end
                        WLK_R: begin
                            if (dig) begin
                                mode <= DIG_R; // start digging right
                            end else if (bump_right || (bump_left && bump_right)) begin
                                // bump right flips to walking left
                                mode <= WLK_L;
                            end else if (bump_left) begin
                                mode <= WLK_R; // bump_left on walking right does nothing, stay walking right
                            end
                            // else no change
                        end
                        DIG_L: begin
                            // Continue digging left until ground disappears
                            // If ground disappears => fall
                            // bumps ignored during digging
                            // dig input ignored during digging
                            // So no mode change here
                            // Already handled ground disappearance above by falling flag
                        end
                        DIG_R: begin
                            // Same as DIG_L mirrored
                        end
                    endcase
                end
            end
        end
    end

    // Outputs: Moore outputs based on mode and falling bit
    assign walk_left  = !falling && (mode == WLK_L);
    assign walk_right = !falling && (mode == WLK_R);
    assign digging    = !falling && ((mode == DIG_L) || (mode == DIG_R));
    assign aaah       = falling;

endmodule