module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
parameter WALKING_LEFT = 2'b00;
parameter WALKING_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Define the direction
parameter LEFT = 1'b0;
parameter RIGHT = 1'b1;

reg [1:0] state;
reg [0:0] direction;
reg digging_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        direction <= LEFT;
        digging_reg <= 1'b0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                    digging_reg <= 1'b1;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                    direction <= RIGHT;
                end else if (bump_right) begin
                    // Do nothing
                end else begin
                    // Do nothing
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                    digging_reg <= 1'b1;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                    direction <= LEFT;
                end else if (bump_left) begin
                    // Do nothing
                end else begin
                    // Do nothing
                end
            end
            FALLING: begin
                if (ground) begin
                    if (direction == LEFT) begin
                        state <= WALKING_LEFT;
                    end else begin
                        state <= WALKING_RIGHT;
                    end
                end else begin
                    // Do nothing
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    digging_reg <= 1'b0;
                end else begin
                    // Do nothing
                end
            end
        endcase
    end
end

always @(*) begin
    if (state == FALLING) begin
        aaah = 1'b1;
    end else begin
        aaah = 1'b0;
    end
    
    if (digging_reg) begin
        digging = 1'b1;
    end else begin
        digging = 1'b0;
    end
    
    if (state == WALKING_LEFT || (state == FALLING && direction == LEFT)) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else if (state == WALKING_RIGHT || (state == FALLING && direction == RIGHT)) begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b0;
    end
end

endmodule