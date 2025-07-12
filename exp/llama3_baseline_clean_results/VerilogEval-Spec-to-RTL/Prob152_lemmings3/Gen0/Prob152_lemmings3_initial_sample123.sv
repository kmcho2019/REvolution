module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state; // 2 bits to represent 4 states
reg [1:0] nextState;
reg prev_walk_dir; // 1 bit to store previous walking direction

// Define states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                nextState = FALLING;
            end else if (dig && ground) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALK_RIGHT;
            end else if (bump_right) begin
                nextState = WALK_LEFT;
            end else begin
                nextState = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                nextState = FALLING;
            end else if (dig && ground) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALK_LEFT;
            end else if (bump_right) begin
                nextState = WALK_RIGHT;
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (prev_walk_dir) begin
                    nextState = WALK_LEFT;
                end else begin
                    nextState = WALK_RIGHT;
                end
            end else begin
                nextState = FALLING;
            end
        end
        DIGGING: begin
            if (~ground) begin
                nextState = FALLING;
            end else begin
                nextState = DIGGING;
            end
        end
        default: begin
            nextState = WALK_LEFT;
        end
    endcase
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            prev_walk_dir = 1'b1;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            prev_walk_dir = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_walk_dir <= 1'b1;
    end else begin
        state <= nextState;
    end
end

endmodule