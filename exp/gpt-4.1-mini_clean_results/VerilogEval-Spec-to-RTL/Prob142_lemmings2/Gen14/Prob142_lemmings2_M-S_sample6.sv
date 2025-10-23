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

    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    always @(*) begin
        next_state = state;
        if (state[1]) begin
            // Falling: resume walking when ground returns
            if (ground)
                next_state = {1'b0, state[0]};
        end else begin
            if (!ground)
                next_state = {1'b1, state[0]};
            else if (bump_left || bump_right)
                next_state = {1'b0, ~state[0]};
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule