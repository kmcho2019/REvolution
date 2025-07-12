module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] nextState;

localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING_LEFT = 2'b10;
localparam FALLING_RIGHT = 2'b11;

always @(*)
begin
    case (state)
        IDLE_LEFT: 
            if (~ground) begin
                nextState = FALLING_LEFT;
            end else if (bump_left) begin
                nextState = IDLE_RIGHT;
            end else if (bump_right) begin
                nextState = IDLE_LEFT;
            end else begin
                nextState = IDLE_LEFT;
            end
        IDLE_RIGHT: 
            if (~ground) begin
                nextState = FALLING_RIGHT;
            end else if (bump_left) begin
                nextState = IDLE_RIGHT;
            end else if (bump_right) begin
                nextState = IDLE_LEFT;
            end else begin
                nextState = IDLE_RIGHT;
            end
        FALLING_LEFT: 
            if (ground) begin
                nextState = IDLE_LEFT;
            end else begin
                nextState = FALLING_LEFT;
            end
        FALLING_RIGHT: 
            if (ground) begin
                nextState = IDLE_RIGHT;
            end else begin
                nextState = FALLING_RIGHT;
            end
        default: begin
            nextState = IDLE_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset)
begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= nextState;
    end
end

always @(*)
begin
    case (state)
        IDLE_LEFT: 
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        IDLE_RIGHT: 
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        FALLING_LEFT: 
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        FALLING_RIGHT: 
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        default: 
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
    endcase
end

endmodule