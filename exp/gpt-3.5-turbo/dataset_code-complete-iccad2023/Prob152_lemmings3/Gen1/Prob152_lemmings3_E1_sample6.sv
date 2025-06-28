module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

// State encoding
parameter [1:0] WALK_LEFT = 2'b00;
parameter [1:0] WALK_RIGHT = 2'b01;
parameter [1:0] FALLING = 2'b10;
parameter [1:0] DIGGING = 2'b11;

reg [1:0] state;

// State transitions and outputs
always @(posedge clk, posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground && !dig) begin
                    state <= FALLING;
                    aaah = 1;
                end else if (!ground && dig) begin
                    state <= DIGGING;
                    digging = 1;
                end else if (bump_right) state <= WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground && !dig) begin
                    state <= FALLING;
                    aaah = 1;
                end else if (!ground && dig) begin
                    state <= DIGGING;
                    digging = 1;
                end else if (bump_left) state <= WALK_LEFT;
            end
            FALLING: begin
                if (ground) begin
                    if (state == WALK_LEFT) state <= WALK_LEFT;
                    else state <= WALK_RIGHT;
                    aaah = 0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    aaah = 1;
                    digging = 0;
                end
            end
        endcase
    end
end

// Output assignment
always @* begin
    walk_left = (state == WALK_LEFT);
    walk_right = (state == WALK_RIGHT);
end

endmodule