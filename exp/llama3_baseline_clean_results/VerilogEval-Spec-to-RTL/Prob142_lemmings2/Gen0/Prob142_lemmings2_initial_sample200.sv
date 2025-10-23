module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;
reg [1:0] prev_state; // Store the previous state when falling

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            if (~ground) begin
                next_state = 2'b10; // FALLING
                prev_state = 2'b00;
            end else if (bump_left) begin
                next_state = 2'b01; // WALK_RIGHT
            end else begin
                next_state = 2'b00; // WALK_LEFT
            end
        end
        2'b01: begin // WALK_RIGHT
            if (~ground) begin
                next_state = 2'b10; // FALLING
                prev_state = 2'b01;
            end else if (bump_right) begin
                next_state = 2'b00; // WALK_LEFT
            end else begin
                next_state = 2'b01; // WALK_RIGHT
            end
        end
        2'b10: begin // FALLING
            if (ground) begin
                next_state = prev_state; // Resume walking
            end else begin
                next_state = 2'b10; // Continue falling
            end
        end
        default: begin
            next_state = 2'b00; // WALK_LEFT
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALK_LEFT
    end else begin
        state <= next_state;
    end
end

assign walk_left = (state == 2'b00); // WALK_LEFT
assign walk_right = (state == 2'b01); // WALK_RIGHT
assign aaah = (state == 2'b10); // FALLING

endmodule