module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 00: walking left, not falling; 01: walking right, not falling; 10: walking left, falling; 11: walking right, falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else if (posedge clk) begin
        if (~ground) begin // ground disappears
            state[1] <= 1'b1; // set falling bit
        end else if (ground) begin // ground reappears
            state[1] <= 1'b0; // reset falling bit
        end
        
        if (bump_left && bump_right) begin
            state[0] <= ~state[0]; // switch direction
        end else if (bump_left) begin
            state[0] <= 1'b0; // switch to walking left
        end else if (bump_right) begin
            state[0] <= 1'b1; // switch to walking right
        end
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left, not falling
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        2'b01: begin // walking right, not falling
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
        end
        2'b10: begin // walking left, falling
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
        2'b11: begin // walking right, falling
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
    endcase
end

endmodule