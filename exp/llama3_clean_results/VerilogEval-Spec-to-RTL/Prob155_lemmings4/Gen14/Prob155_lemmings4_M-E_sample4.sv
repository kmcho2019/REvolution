module TopModule(
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

enum logic [1:0] {WALKING, FALLING, DIGGING, SPLATTERED} state;
reg [4:0] fall_count;
reg direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        fall_count <= 5'b0;
        direction <= 1'b1; // left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end else if (dig) begin
                    state <= DIGGING;
                end else begin
                    if (bump_left) begin
                        direction <= 1'b0; // right
                    end else if (bump_right) begin
                        direction <= 1'b1; // left
                    end
                end
                walk_left <= direction;
                walk_right <= ~direction;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end else if (!dig) begin
                    state <= WALKING;
                end
                walk_left <= direction;
                walk_right <= ~direction;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            SPLATTERED: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule