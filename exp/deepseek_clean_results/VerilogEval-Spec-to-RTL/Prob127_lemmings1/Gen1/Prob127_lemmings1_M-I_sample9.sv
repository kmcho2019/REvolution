module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;
    
    // State register with asynchronous reset and direct transition logic
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;
        else begin
            case (state)
                LEFT: state <= bump_left ? RIGHT : LEFT;
                RIGHT: state <= bump_right ? LEFT : RIGHT;
            endcase
        end
    end
    
    // Combined output logic
    assign {walk_left, walk_right} = (state == LEFT) ? 2'b10 : 2'b01;

endmodule