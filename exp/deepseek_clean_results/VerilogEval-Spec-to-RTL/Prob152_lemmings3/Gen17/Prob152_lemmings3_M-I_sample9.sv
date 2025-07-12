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

    // Combined bump signal and direction change detection
    wire bump_change = (bump_left | bump_right) & (bump_left ^ bump_right);
    wire new_direction = bump_left ? 1'b1 : 1'b0;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // WALK
            direction <= 1'b0; // left
        end else begin
            case (state)
                2'b00: begin // WALK
                    if (~ground) begin
                        state <= 2'b01; // FALL
                    end else if (dig) begin
                        state <= 2'b10; // DIG
                    end else if (bump_change) begin
                        direction <= new_direction;
                    end
                end
                
                2'b01: begin // FALL
                    if (ground) state <= 2'b00; // WALK
                end
                
                2'b10: begin // DIG
                    if (~ground) state <= 2'b01; // FALL
                end
            endcase
        end
    end

    // Optimized output logic using state bits directly
    assign walk_left = ~state[1] & ~state[0] & ~direction;
    assign walk_right = ~state[1] & ~state[0] & direction;
    assign aaah = state[0];
    assign digging = state[1];

endmodule