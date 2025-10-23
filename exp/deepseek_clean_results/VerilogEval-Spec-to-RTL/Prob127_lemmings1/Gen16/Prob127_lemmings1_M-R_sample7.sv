module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;  // LEFT or RIGHT

    // State register with async reset and direct transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else begin
            case (state)
                LEFT:  state <= bump_left ? RIGHT : LEFT;
                RIGHT: state <= bump_right ? LEFT : RIGHT;
            endcase
        end
    end

    // Combined output assignment
    assign {walk_left, walk_right} = (state == LEFT) ? 2'b10 : 2'b01;

endmodule