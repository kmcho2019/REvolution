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

enum logic [1:0] {IDLE, WALKING, FALLING, DIGGING, SPLATTERED} state, next_state;
reg [4:0] fall_count;
reg direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        fall_count <= 5'b0;
        direction <= 1'b1; // left
    end else begin
        case (state)
            IDLE: begin
                state <= WALKING;
                direction <= 1'b1; // left
            end
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    direction <= 1'b0; // right
                end else if (bump_right) begin
                    direction <= 1'b1; // left
                end
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
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end else if (!dig) begin
                    state <= WALKING;
                end
            end
            SPLATTERED: begin
                // No state transition
            end
        endcase
    end
end

assign walk_left = (state == WALKING || state == DIGGING) && direction;
assign walk_right = (state == WALKING || state == DIGGING) && ~direction;
assign aaah = state == FALLING;
assign digging = state == DIGGING;

endmodule