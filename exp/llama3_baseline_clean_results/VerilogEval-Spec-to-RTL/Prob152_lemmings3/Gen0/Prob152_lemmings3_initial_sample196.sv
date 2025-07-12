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

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING
reg prev_dir; // 0: WALK_LEFT, 1: WALK_RIGHT

// State encoding
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_dir <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                    prev_dir <= 1;
                end else if (bump_right) begin
                    // No need to change state or prev_dir
                end else begin
                    // No need to change state or prev_dir
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    // No need to change state or prev_dir
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                    prev_dir <= 0;
                end else begin
                    // No need to change state or prev_dir
                end
            end
            FALLING: begin
                if (ground) begin
                    if (prev_dir == 0) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                end
            end
        endcase
    end
end

assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule