module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// State encoding
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter STOPPED = 2'b11;

// Walking direction encoding
parameter LEFT = 1'b0;
parameter RIGHT = 1'b1;

reg [1:0] state;
reg [0:0] walk_direction;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        walk_direction <= LEFT;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (bump_left || bump_right) begin
                    state <= STOPPED;
                    if (bump_left) begin
                        walk_direction <= RIGHT;
                    end else begin
                        walk_direction <= LEFT;
                    end
                end
            end
            IDLE_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (bump_left || bump_right) begin
                    state <= STOPPED;
                    if (bump_right) begin
                        walk_direction <= LEFT;
                    end else begin
                        walk_direction <= RIGHT;
                    end
                end
            end
            FALLING: begin
                if (ground) begin
                    if (walk_direction == LEFT) begin
                        state <= IDLE_LEFT;
                    end else begin
                        state <= IDLE_RIGHT;
                    end
                end
            end
            STOPPED: begin
                if (walk_direction == LEFT) begin
                    state <= IDLE_LEFT;
                end else begin
                    state <= IDLE_RIGHT;
                end
            end
        endcase
    end
end

assign walk_left = (state == IDLE_LEFT);
assign walk_right = (state == IDLE_RIGHT);
assign aaah = (state == FALLING);

endmodule