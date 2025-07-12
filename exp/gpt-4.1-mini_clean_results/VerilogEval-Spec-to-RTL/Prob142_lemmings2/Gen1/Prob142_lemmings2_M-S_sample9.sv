module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);
    // State bits: [1] falling, [0] direction (0=left,1=right)
    reg [1:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walking left, not falling
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            2'b00: begin // walking left, not falling
                if (!ground) begin
                    next_state = 2'b10; // falling, direction=0 (left)
                end else if (bump_left || bump_right) begin
                    next_state = 2'b01; // walking right, not falling
                end
            end
            2'b01: begin // walking right, not falling
                if (!ground) begin
                    next_state = 2'b11; // falling, direction=1 (right)
                end else if (bump_left || bump_right) begin
                    next_state = 2'b00; // walking left, not falling
                end
            end
            2'b10: begin // falling, direction=left
                if (ground) begin
                    next_state = 2'b00; // resume walking left
                end
                // bumps ignored during falling
            end
            2'b11: begin // falling, direction=right
                if (ground) begin
                    next_state = 2'b01; // resume walking right
                end
                // bumps ignored during falling
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

        if (state[1]) begin
            // falling
            aaah = 1;
        end else begin
            // walking
            walk_left = (state[0] == 1'b0);
            walk_right = (state[0] == 1'b1);
        end
    end
endmodule