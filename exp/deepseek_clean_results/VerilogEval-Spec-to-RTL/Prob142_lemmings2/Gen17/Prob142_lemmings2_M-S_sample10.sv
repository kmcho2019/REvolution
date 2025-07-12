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

    reg [1:0] state;  // [1]: FALL, [0]: direction

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // WALK left
        end
        else if (state[1]) begin  // FALL state
            state[1] <= ~ground;
        end
        else if (~ground) begin  // Start FALL
            state[1] <= 1'b1;
        end
        else if ((state[0] ? bump_right : bump_left)) begin  // Toggle direction
            state[0] <= ~state[0];
        end
    end

    assign {aaah, walk_right} = state;
    assign walk_left = ~state[1] & ~state[0];

endmodule