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

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state
reg [4:0] fallCounter; // Counter for falling cycles
reg [1:0] direction; // Direction the Lemming was walking before falling or digging

// Define states
localparam WALK_LEFT = 3'b001;
localparam WALK_RIGHT = 3'b010;
localparam FALL = 3'b011;
localparam DIG = 3'b100;
localparam SPLATTER = 3'b111;

// Define directions
localparam LEFT = 2'b01;
localparam RIGHT = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= LEFT;
        fallCounter <= 5'b0;
    end else begin
        state <= nextState;
        if (nextState == FALL) begin
            fallCounter <= fallCounter + 1'b1;
        end else begin
            fallCounter <= 5'b0;
        end
    end
end

always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (dig && ground) begin
                nextState = DIG;
            end else if (~ground) begin
                nextState = FALL;
            end else if (bump_left) begin
                nextState = WALK_RIGHT;
                direction = RIGHT;
            end else if (bump_right) begin
                nextState = WALK_LEFT;
                direction = LEFT;
            end else begin
                nextState = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (dig && ground) begin
                nextState = DIG;
            end else if (~ground) begin
                nextState = FALL;
            end else if (bump_left) begin
                nextState = WALK_LEFT;
                direction = LEFT;
            end else if (bump_right) begin
                nextState = WALK_RIGHT;
                direction = RIGHT;
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALL: begin
            aaah = 1'b1;
            if (ground) begin
                if (fallCounter > 5'b10100) begin
                    nextState = SPLATTER;
                end else begin
                    if (direction == LEFT) begin
                        nextState = WALK_LEFT;
                    end else begin
                        nextState = WALK_RIGHT;
                    end
                end
            end else begin
                nextState = FALL;
            end
        end
        DIG: begin
            digging = 1'b1;
            if (~ground) begin
                nextState = FALL;
            end else begin
                nextState = DIG;
            end
        end
        SPLATTER: begin
            nextState = SPLATTER;
        end
    endcase
end

endmodule