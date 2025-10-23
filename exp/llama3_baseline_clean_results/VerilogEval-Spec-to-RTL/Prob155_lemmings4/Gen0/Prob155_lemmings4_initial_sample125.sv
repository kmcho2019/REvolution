`define IDLE_LEFT 4'd0
`define IDLE_RIGHT 4'd1
`define FALLING 4'd2
`define DIGGING 4'd3
`define SPLATTERED 4'd4

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
reg [3:0] nextState;
reg [5:0] fall_count;
reg original_direction;

always @(*) begin
    case (state)
        `IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (ground == 1'b0) begin
                nextState = `FALLING;
            end else if (dig == 1'b1) begin
                nextState = `DIGGING;
                original_direction = 1'b1;
            end else if (bump_left == 1'b1) begin
                nextState = `IDLE_RIGHT;
            end else if (bump_right == 1'b1) begin
                nextState = `IDLE_LEFT;
            end else begin
                nextState = `IDLE_LEFT;
            end
        end
        `IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (ground == 1'b0) begin
                nextState = `FALLING;
            end else if (dig == 1'b1) begin
                nextState = `DIGGING;
                original_direction = 1'b0;
            end else if (bump_left == 1'b1) begin
                nextState = `IDLE_LEFT;
            end else if (bump_right == 1'b1) begin
                nextState = `IDLE_RIGHT;
            end else begin
                nextState = `IDLE_RIGHT;
            end
        end
        `FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground == 1'b1) begin
                if (fall_count > 20) begin
                    nextState = `SPLATTERED;
                end else if (original_direction == 1'b1) begin
                    nextState = `IDLE_LEFT;
                end else begin
                    nextState = `IDLE_RIGHT;
                end
            end else begin
                nextState = `FALLING;
            end
        end
        `DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (ground == 1'b0) begin
                nextState = `FALLING;
                if (original_direction == 1'b1) begin
                    original_direction = 1'b1;
                end else begin
                    original_direction = 1'b0;
                end
            end else begin
                nextState = `DIGGING;
            end
        end
        `SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            nextState = `SPLATTERED;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            nextState = `IDLE_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `IDLE_LEFT;
        fall_count <= 6'd0;
        original_direction <= 1'b1;
    end else begin
        state <= nextState;
        if (state == `FALLING) begin
            fall_count <= fall_count + 1'b1;
        end else begin
            fall_count <= 6'd0;
        end
    end
end

endmodule