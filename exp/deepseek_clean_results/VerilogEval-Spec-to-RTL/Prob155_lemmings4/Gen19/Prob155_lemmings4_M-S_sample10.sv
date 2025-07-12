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

    // Combined state encoding: [direction, state]
    // direction: 1=left, 0=right
    // state: 00=WALK, 01=FALL, 10=DIG, 11=SPLAT
    reg [2:0] state;  // {direction, state[1:0]}
    
    // Fall timer (5 bits, counts 0-20)
    reg [4:0] fall_cycles;
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 3'b100;  // WALK_LEFT
            fall_cycles <= 0;
        end else begin
            case (state[1:0])
                // WALK state
                2'b00: begin
                    if (!ground) begin
                        state <= {state[2], 2'b01};  // FALL
                        fall_cycles <= 1;
                    end else if (dig) begin
                        state <= {state[2], 2'b10};  // DIG
                    end else begin
                        // Handle direction changes
                        if (bump_left && !bump_right)
                            state[2] <= 1'b0;  // RIGHT
                        else if (bump_right && !bump_left)
                            state[2] <= 1'b1;  // LEFT
                        else if (bump_left && bump_right)
                            state[2] <= ~state[2];  // Toggle
                    end
                end
                
                // FALL state
                2'b01: begin
                    if (ground) begin
                        if (fall_cycles > 20)
                            state <= 3'b011;  // SPLAT
                        else
                            state <= {state[2], 2'b00};  // WALK
                        fall_cycles <= 0;
                    end else if (fall_cycles < 20) begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end
                
                // DIG state
                2'b10: begin
                    if (!ground) begin
                        state <= {state[2], 2'b01};  // FALL
                        fall_cycles <= 1;
                    end
                end
                
                // SPLAT state - no transitions
                default: ;
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state[1:0] == 2'b00) & state[2];
    assign walk_right = (state[1:0] == 2'b00) & ~state[2];
    assign aaah = (state[1:0] == 2'b01);
    assign digging = (state[1:0] == 2'b10);

endmodule