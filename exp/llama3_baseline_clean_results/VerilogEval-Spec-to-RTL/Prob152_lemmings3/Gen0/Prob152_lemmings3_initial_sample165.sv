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

    reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING
    reg [1:0] nextState;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0; // WALK_LEFT
        end else begin
            state <= nextState;
        end
    end

    always @(*) begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    nextState = 2; // FALLING
                end else if (dig) begin
                    nextState = 3; // DIGGING
                end else if (bump_left) begin
                    nextState = 1; // WALK_RIGHT
                end else if (bump_right) begin
                    nextState = 0; // WALK_LEFT
                end else begin
                    nextState = 0; // WALK_LEFT
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    nextState = 2; // FALLING
                end else if (dig) begin
                    nextState = 3; // DIGGING
                end else if (bump_right) begin
                    nextState = 0; // WALK_LEFT
                end else if (bump_left) begin
                    nextState = 1; // WALK_RIGHT
                end else begin
                    nextState = 1; // WALK_RIGHT
                end
            end
            2: begin // FALLING
                if (ground) begin
                    if (state == 2) begin // was falling, now walking
                        nextState = (bump_left) ? 0 : (bump_right) ? 1 : (state == 0) ? 0 : 1;
                    end else begin
                        nextState = state;
                    end
                end else begin
                    nextState = 2; // FALLING
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    nextState = 2; // FALLING
                end else begin
                    nextState = 3; // DIGGING
                end
            end
            default: begin
                nextState = 0; // WALK_LEFT
            end
        endcase
    end

    assign walk_left = (state == 0);
    assign walk_right = (state == 1);
    assign aaah = (state == 2);
    assign digging = (state == 3);

endmodule