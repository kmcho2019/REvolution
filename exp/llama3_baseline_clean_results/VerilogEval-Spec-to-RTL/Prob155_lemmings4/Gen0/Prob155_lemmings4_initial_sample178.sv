module TopModule (
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

reg [3:0] state;
reg [4:0] fall_count;
reg prev_ground;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001;  // walking left
        fall_count <= 5'b00000;
        prev_ground <= 1'b1;
    end else begin
        case (state)
            4'b0001: begin  // walking left
                if (~ground) begin
                    state <= 4'b0010;  // falling
                    fall_count <= 5'b00001;
                end else if (dig) begin
                    state <= 4'b0100;  // digging left
                end else if (bump_left) begin
                    state <= 4'b1000;  // walking right
                end else if (bump_right) begin
                    state <= 4'b0001;  // walking left
                end
            end
            4'b1000: begin  // walking right
                if (~ground) begin
                    state <= 4'b0010;  // falling
                    fall_count <= 5'b00001;
                end else if (dig) begin
                    state <= 4'b0101;  // digging right
                end else if (bump_right) begin
                    state <= 4'b0001;  // walking left
                end else if (bump_left) begin
                    state <= 4'b1000;  // walking right
                end
            end
            4'b0010: begin  // falling
                if (ground) begin
                    if (fall_count > 5'b10100) begin
                        state <= 4'b1100;  // splattered
                    end else if (prev_ground) begin
                        state <= 4'b0001;  // walking left
                    end else begin
                        state <= 4'b1000;  // walking right
                    end
                    fall_count <= 5'b00000;
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            4'b0100: begin  // digging left
                if (~ground) begin
                    state <= 4'b0010;  // falling
                    fall_count <= 5'b00001;
                end else if (~dig) begin
                    state <= 4'b0001;  // walking left
                end
            end
            4'b0101: begin  // digging right
                if (~ground) begin
                    state <= 4'b0010;  // falling
                    fall_count <= 5'b00001;
                end else if (~dig) begin
                    state <= 4'b1000;  // walking right
                end
            end
            4'b1100: begin  // splattered
                state <= 4'b1100;  // stay splattered
            end
        endcase
        prev_ground <= ground;
    end
end

always @(*) begin
    walk_left = (state == 4'b0001 || state == 4'b0100);
    walk_right = (state == 4'b1000 || state == 4'b0101);
    aaah = (state == 4'b0010);
    digging = (state == 4'b0100 || state == 4'b0101);
end

endmodule