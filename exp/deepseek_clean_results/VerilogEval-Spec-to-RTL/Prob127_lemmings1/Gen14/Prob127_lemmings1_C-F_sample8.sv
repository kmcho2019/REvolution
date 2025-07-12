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

    // Optimized XOR-based state transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= state ^ (state ? bump_right : bump_left);
    end

    // Efficient output assignments using implicit checks
    assign walk_left = ~state;
    assign walk_right = state;

endmodule