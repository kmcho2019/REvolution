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

    // State encoding: 00=WALK, 01=FALL, 10=DIG
    reg [1:0] state;
    reg direction; // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            direction <= 0;
        end else begin
            case (state)
                2'b00: begin // WALK
                    if (!ground) begin
                        state <= 2'b01; // Fall
                    end else if (dig) begin
                        state <= 2'b10; // Dig
                    end else begin
                        // Handle bumps with priority to simultaneous case
                        if (bump_left ^ bump_right)
                            direction <= bump_left;
                        else if (bump_left & bump_right)
                            direction <= ~direction;
                    end
                end
                
                2'b01: begin // FALL
                    if (ground)
                        state <= 2'b00; // Return to walking
                end
                
                2'b10: begin // DIG
                    if (!ground)
                        state <= 2'b01; // Start falling
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == 2'b00) & ~direction;
    assign walk_right = (state == 2'b00) & direction;
    assign aaah       = (state == 2'b01);
    assign digging    = (state == 2'b10);

endmodule