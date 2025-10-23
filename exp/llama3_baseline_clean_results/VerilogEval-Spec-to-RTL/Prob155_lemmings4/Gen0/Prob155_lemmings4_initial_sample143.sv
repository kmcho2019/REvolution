module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    reg [1:0] state;
    reg [1:0] nextState;
    reg direction;
    reg [4:0] fallCount;

    localparam WALKING_LEFT = 2'b00;
    localparam WALKING_RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    localparam DIGGING = 2'b11;
    localparam SPLATTERED = 2'b00;

    always @(*) begin
        case(state)
            WALKING_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
                if (~ground) begin
                    nextState = FALLING;
                end else if (dig) begin
                    nextState = DIGGING;
                end else if (bump_left) begin
                    nextState = WALKING_RIGHT;
                end else if (bump_right) begin
                    nextState = WALKING_LEFT;
                end else begin
                    nextState = WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
                if (~ground) begin
                    nextState = FALLING;
                end else if (dig) begin
                    nextState = DIGGING;
                end else if (bump_left) begin
                    nextState = WALKING_LEFT;
                end else if (bump_right) begin
                    nextState = WALKING_RIGHT;
                end else begin
                    nextState = WALKING_RIGHT;
                end
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
                if (ground) begin
                    if (fallCount > 5'd20) begin
                        nextState = SPLATTERED;
                    end else begin
                        if (direction) begin
                            nextState = WALKING_LEFT;
                        end else begin
                            nextState = WALKING_RIGHT;
                        end
                    end
                end else begin
                    nextState = FALLING;
                end
            end
            DIGGING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
                if (~ground) begin
                    nextState = FALLING;
                end else begin
                    nextState = DIGGING;
                end
            end
            SPLATTERED: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
                nextState = SPLATTERED;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state = WALKING_LEFT;
            fallCount = 5'd0;
            direction = 1'b0;
        end else begin
            state = nextState;
            if (state == FALLING) begin
                fallCount = fallCount + 1'b1;
            end else begin
                fallCount = 5'd0;
            end
            if ((state == WALKING_LEFT) || (state == DIGGING && direction == 1'b0)) begin
                direction = 1'b0;
            end else if ((state == WALKING_RIGHT) || (state == DIGGING && direction == 1'b1)) begin
                direction = 1'b1;
            end
        end
    end

endmodule