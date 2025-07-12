module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [2:0] state;
reg [2:0] nextState;
reg [4:0] fallCount;
reg fallCountEn;
reg originalDirection; // 1 for right, 0 for left
reg splattered;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b001; // walking left
        fallCount <= 5'b0;
        originalDirection <= 1'b0; // left
        splattered <= 1'b0;
    end else begin
        state <= nextState;
        fallCount <= (fallCountEn) ? fallCount + 1 : fallCount;
    end
end

always @(*) begin
    case (state)
        3'b001: // walking left
            if (!ground) begin
                nextState = 3'b010; // falling
                fallCountEn = 1'b1;
            end else if (dig && ground) begin
                nextState = 3'b011; // digging
                fallCountEn = 1'b0;
            end else if (bump_left) begin
                nextState = 3'b100; // walking right
                originalDirection = 1'b1; // right
                fallCountEn = 1'b0;
            end else if (bump_right) begin
                nextState = 3'b001; // walking left
                originalDirection = 1'b0; // left
                fallCountEn = 1'b0;
            end else begin
                nextState = 3'b001; // walking left
                fallCountEn = 1'b0;
            end
        3'b100: // walking right
            if (!ground) begin
                nextState = 3'b010; // falling
                fallCountEn = 1'b1;
            end else if (dig && ground) begin
                nextState = 3'b011; // digging
                fallCountEn = 1'b0;
            end else if (bump_left) begin
                nextState = 3'b001; // walking left
                originalDirection = 1'b0; // left
                fallCountEn = 1'b0;
            end else if (bump_right) begin
                nextState = 3'b100; // walking right
                originalDirection = 1'b1; // right
                fallCountEn = 1'b0;
            end else begin
                nextState = 3'b100; // walking right
                fallCountEn = 1'b0;
            end
        3'b010: // falling
            if (ground) begin
                if (fallCount > 5'b10100) begin // 20
                    nextState = 3'b111; // splattered
                    splattered = 1'b1;
                end else begin
                    nextState = (originalDirection) ? 3'b100 : 3'b001;
                end
                fallCountEn = 1'b0;
            end else begin
                nextState = 3'b010; // falling
                fallCountEn = 1'b1;
            end
        3'b011: // digging
            if (!ground) begin
                nextState = 3'b010; // falling
                fallCountEn = 1'b1;
            end else begin
                nextState = 3'b011; // digging
                fallCountEn = 1'b0;
            end
        3'b111: // splattered
            nextState = 3'b111; // splattered
            fallCountEn = 1'b0;
        default: begin
            nextState = 3'b001; // walking left
            fallCountEn = 1'b0;
        end
    endcase
end

always @(*) begin
    case (state)
        3'b001: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b100: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b010: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        3'b011: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        3'b111: begin // splattered
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase

    if (splattered) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end
end

endmodule