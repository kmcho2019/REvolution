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

    reg [1:0] state; // bit0 = direction (0=left,1=right), bit1 = falling (0=walking,1=falling)

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left, not falling
        else begin
            if (state[1]) begin // currently falling
                if (ground)
                    state[1] <= 1'b0; // land, stop falling
            end else begin // walking
                if (!ground)
                    state[1] <= 1'b1; // start falling
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        state[0] <= ~state[0]; // both bumps flip direction
                    else
                        state[0] <= bump_left ? 1'b1 : 1'b0; // bump left -> walk right, bump right -> walk left
                end
            end
        end
    end

    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule