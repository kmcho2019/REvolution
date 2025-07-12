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

    // State encoding: [1] = fall, [0] = direction (0=left, 1=right)
    reg [1:0] state;  // 00=WALK_LEFT, 01=WALK_RIGHT, 10=FALL_LEFT, 11=FALL_RIGHT

    // Pre-compute bump conditions
    wire bump_left_active = bump_left && (state[0] == 0);
    wire bump_right_active = bump_right && (state[0] == 1);

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Reset to walk left
        end
        else begin
            case (state)
                2'b00: // WALK_LEFT
                    state <= !ground ? 2'b10 : 
                            (bump_left_active ? 2'b01 : 2'b00);
                
                2'b01: // WALK_RIGHT
                    state <= !ground ? 2'b11 :
                            (bump_right_active ? 2'b00 : 2'b01);
                
                2'b10: // FALL_LEFT
                    state <= ground ? 2'b00 : 2'b10;
                
                2'b11: // FALL_RIGHT
                    state <= ground ? 2'b01 : 2'b11;
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = state[1];

endmodule