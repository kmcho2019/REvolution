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

    // State encoding
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    
    reg [1:0] state;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (state)
                LEFT:    state <= ground ? (bump_left ? RIGHT : LEFT) : FALLING;
                RIGHT:   state <= ground ? (bump_right ? LEFT : RIGHT) : FALLING;
                FALLING: state <= ground ? (state == LEFT ? LEFT : RIGHT) : FALLING;
                default: state <= LEFT;
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);

endmodule