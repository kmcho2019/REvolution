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

    // State encoding
    reg [1:0] state;  // 00:LEFT, 01:RIGHT, 10:FALLING
    reg is_digging;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // Start walking left
            is_digging <= 0;
        end else begin
            case (state)
                2'b00, 2'b01: begin  // Walking left or right
                    if (~ground) begin
                        state <= 2'b10;  // Fall
                        is_digging <= 0;
                    end else if (dig & ~is_digging) begin
                        is_digging <= 1;
                    end else if (~is_digging) begin
                        // Handle bumps only when not digging
                        if (bump_left) state <= 2'b01;
                        if (bump_right) state <= 2'b00;
                        if (bump_left & bump_right) state <= ~state;
                    end
                end
                2'b10: begin  // Falling
                    if (ground) begin
                        state <= state[1] ? state : (is_digging ? state : state);
                        is_digging <= 0;
                    end
                end
            endcase
            
            // Stop digging if ground disappears
            if (is_digging & ~ground) begin
                state <= 2'b10;
                is_digging <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == 2'b00) & ~is_digging & ground;
    assign walk_right = (state == 2'b01) & ~is_digging & ground;
    assign aaah = (state == 2'b10);
    assign digging = is_digging & ground;

endmodule