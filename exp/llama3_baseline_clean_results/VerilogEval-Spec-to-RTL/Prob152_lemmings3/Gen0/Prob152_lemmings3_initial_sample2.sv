module TopModule (
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

// State machine states
reg [1:0] state;
reg [1:0] next_state;

// Enum for states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALL = 2'b10;
localparam DIG = 2'b11;

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (ground == 0) next_state = FALL;
            else if (dig == 1) next_state = DIG;
            else if (bump_left == 1) next_state = WALK_RIGHT;
            else if (bump_right == 1) next_state = WALK_LEFT;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (ground == 0) next_state = FALL;
            else if (dig == 1) next_state = DIG;
            else if (bump_left == 1) next_state = WALK_LEFT;
            else if (bump_right == 1) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
        end
        FALL: begin
            if (ground == 1) next_state = WALK_LEFT;
            else next_state = FALL;
        end
        DIG: begin
            if (ground == 0) next_state = FALL;
            else next_state = DIG;
        end
        default: next_state = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= WALK_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end
    else begin
        state <= next_state;
        case (next_state)
            WALK_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            WALK_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            FALL: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            DIG: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            default: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule