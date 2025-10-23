module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    // One-hot state encoding: bit0 = WALK_LEFT, bit1 = WALK_RIGHT
    reg [1:0] state;

    // Asynchronous reset: initialize to WALK_LEFT = 2'b01
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;        // walk_left active
        end else begin
            if (bump_left || bump_right) begin
                // Toggle state by rotating bits left/right
                state <= {state[0], state[1]};
            end
            // else retain current state
        end
    end

    // Outputs directly reflect the current state bits
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            walk_left  <= state[0];
            walk_right <= state[1];
        end
    end

endmodule