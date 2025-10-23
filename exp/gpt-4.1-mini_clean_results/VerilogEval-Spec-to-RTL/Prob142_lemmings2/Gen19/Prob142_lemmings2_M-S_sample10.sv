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

    reg [1:0] state, next_state; // [1]=falling, [0]=direction (0=left,1=right)

    always @(*) begin
        next_state = state;
        if (state[1]) begin
            // falling: resume walking if ground returns, else stay falling
            if (ground)
                next_state = {1'b0, state[0]};
        end else begin
            if (!ground)
                next_state = {1'b1, state[0]}; // start falling
            else if (bump_left || bump_right)
                next_state = {1'b0, ~state[0]}; // flip direction on any bump
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left, not falling
        else
            state <= next_state;
    end

    assign aaah = state[1];
    assign walk_left = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule