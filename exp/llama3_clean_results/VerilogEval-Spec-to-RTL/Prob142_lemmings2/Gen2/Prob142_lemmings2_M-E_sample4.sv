module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states using a binary encoding
reg [0:0] state;
localparam WALK_LEFT = 1'b0;
localparam WALK_RIGHT = 1'b1;

// Define the signals for the output generator
reg falling;

// Control unit to determine the next state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        falling <= 1'b0;
    end else begin
        if (~ground) begin
            falling <= 1'b1;
        end else if (ground && falling) begin
            falling <= 1'b0;
        end

        if (bump_left && ~bump_right) begin
            state <= WALK_RIGHT;
        end else if (bump_right && ~bump_left) begin
            state <= WALK_LEFT;
        end else if (bump_left && bump_right) begin
            // Switch directions when bumped on both sides
            state <= ~state;
        end
    end
end

// Output generator to produce the output signals
always @(*) begin
    if (falling) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else begin
        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
            default: begin
                // Handle invalid states
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        endcase
    end
end

endmodule