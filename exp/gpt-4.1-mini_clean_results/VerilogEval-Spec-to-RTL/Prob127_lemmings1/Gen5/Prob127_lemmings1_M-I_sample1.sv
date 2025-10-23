module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;

    // State register with async active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else if (bump_left || bump_right)
            state <= ~state;
    end

    // Registered outputs for Moore FSM
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            walk_left  <= (state == WALK_LEFT);
            walk_right <= (state == WALK_RIGHT);
        end
    end

endmodule