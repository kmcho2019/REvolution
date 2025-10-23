module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg [1:0] state; // state[1]=falling, state[0]=direction (0=left,1=right)
    reg [1:0] next_state;

    always @* begin
        if (state[1]) begin
            // Falling: stay falling until ground returns
            next_state = ground ? {1'b0, state[0]} : state;
        end else begin
            if (!ground)
                next_state = {1'b1, state[0]};
            else if (bump_left || bump_right)
                next_state = {1'b0, ~state[0]};
            else
                next_state = state;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left, not falling
        else
            state <= next_state;
    end

    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule