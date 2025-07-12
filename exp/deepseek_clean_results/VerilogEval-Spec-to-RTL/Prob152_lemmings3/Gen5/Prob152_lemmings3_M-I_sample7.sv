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

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;
    localparam DIGGING    = 2'b11;
    
    reg [1:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (~ground) begin
                        state <= FALLING;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if ((state == WALK_LEFT && bump_left) || 
                                (state == WALK_RIGHT && bump_right)) begin
                        state <= state == WALK_LEFT ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        state <= state[0] ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                DIGGING: begin
                    if (~ground) begin
                        state <= FALLING;
                    end
                end
            endcase
        end
    end

    // Output logic - optimized to use minimal gates
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule