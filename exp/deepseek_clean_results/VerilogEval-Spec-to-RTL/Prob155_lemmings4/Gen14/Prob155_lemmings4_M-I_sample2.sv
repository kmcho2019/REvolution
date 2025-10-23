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

    // Movement direction
    reg move_left;  // 1 = left, 0 = right

    // Action states (one-hot)
    reg is_falling;
    reg is_digging;
    reg is_splattered;

    // Fall timer
    reg [4:0] fall_cycles;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            move_left <= 1'b1;
            is_falling <= 1'b0;
            is_digging <= 1'b0;
            is_splattered <= 1'b0;
            fall_cycles <= 5'b0;
        end else if (!is_splattered) begin
            // Handle falling first (highest priority)
            if (!ground) begin
                is_falling <= 1'b1;
                is_digging <= 1'b0;
                fall_cycles <= fall_cycles + 1'b1;
            end else if (is_falling) begin
                is_falling <= 1'b0;
                is_splattered <= (fall_cycles > 20);
                fall_cycles <= 5'b0;
            end 
            // Handle digging (medium priority)
            else if (dig && !is_falling) begin
                is_digging <= 1'b1;
            end else if (is_digging && ground) begin
                // Continue digging while on ground
            end else begin
                // Normal walking (lowest priority)
                is_digging <= 1'b0;
                case ({bump_left, bump_right})
                    2'b01: move_left <= 1'b0;
                    2'b10: move_left <= 1'b1;
                    2'b11: move_left <= ~move_left;
                    default: ; // Keep current direction
                endcase
            end
        end
    end

    // Output logic
    assign walk_left = ~is_splattered & ~is_falling & ~is_digging & move_left;
    assign walk_right = ~is_splattered & ~is_falling & ~is_digging & ~move_left;
    assign aaah = is_falling;
    assign digging = is_digging;

endmodule