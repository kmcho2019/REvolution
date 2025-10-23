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

    reg [1:0] state;
    // States:
    // 0 = walk left
    // 1 = walk right
    // 2 = fall left
    // 3 = fall right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'd0; // walk left
        end else begin
            case (state)
                2'd0, 2'd1: begin // walking states
                    if (!ground)
                        state <= state + 2'd2; // start falling, keep direction
                    else begin
                        if (bump_left && bump_right)
                            state <= state ^ 2'd1; // flip direction
                        else if (bump_left)
                            state <= 2'd1; // walk right
                        else if (bump_right)
                            state <= 2'd0; // walk left
                    end
                end
                2'd2, 2'd3: begin // falling states
                    if (ground)
                        state <= state - 2'd2; // resume walking same direction
                    // bumps ignored while falling
                end
            endcase
        end
    end

    assign aaah       = (state[1] == 1'b1);       // falling states have MSB=1
    assign walk_left  = (state == 2'd0);
    assign walk_right = (state == 2'd1);

endmodule