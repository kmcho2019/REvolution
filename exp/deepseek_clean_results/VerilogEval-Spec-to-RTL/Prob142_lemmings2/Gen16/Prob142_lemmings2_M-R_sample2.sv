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

    // State definitions
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT = 2'b10;
    localparam FALL_RIGHT = 2'b11;
    
    reg [1:0] state;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT:  state <= ground ? (bump_left ? WALK_RIGHT : WALK_LEFT) : FALL_LEFT;
                WALK_RIGHT: state <= ground ? (bump_right ? WALK_LEFT : WALK_RIGHT) : FALL_RIGHT;
                FALL_LEFT:  state <= ground ? WALK_LEFT : FALL_LEFT;
                FALL_RIGHT: state <= ground ? WALK_RIGHT : FALL_RIGHT;
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule