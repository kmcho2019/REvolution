module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define states
enum {WL, WR, FL, FR} state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            WL: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
            end
            WR: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
            end
            FL: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
            end
            FR: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        WL: begin
            if (~ground) begin
                next_state = FL;
            end else if (bump_left) begin
                next_state = WR;
            end else if (bump_right) begin
                next_state = WL;
            end else begin
                next_state = WL;
            end
        end
        WR: begin
            if (~ground) begin
                next_state = FR;
            end else if (bump_left) begin
                next_state = WL;
            end else if (bump_right) begin
                next_state = WL;
            end else begin
                next_state = WR;
            end
        end
        FL: begin
            if (ground) begin
                next_state = WL;
            end else begin
                next_state = FL;
            end
        end
        FR: begin
            if (ground) begin
                next_state = WR;
            end else begin
                next_state = FR;
            end
        end
    endcase
end

endmodule