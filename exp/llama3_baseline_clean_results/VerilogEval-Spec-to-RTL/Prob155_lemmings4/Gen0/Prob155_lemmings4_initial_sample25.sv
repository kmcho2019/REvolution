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

reg [1:0] state; // 2-bit state register
reg [4:0] fall_count; // 5-bit counter for falling time
reg walk_dir; // register to store walking direction

localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;
localparam SPLATTERED = 2'b11;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_dir <= 1'b0; // initialize walking direction to left
        fall_count <= 5'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else if (dig) begin
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left && !bump_right) begin
                    walk_dir <= 1'b1; // switch to walking right
                end else if (!bump_left && bump_right) begin
                    walk_dir <= 1'b0; // switch to walking left
                end else if (bump_left && bump_right) begin
                    walk_dir <= ~walk_dir; // switch direction
                end
                if (walk_dir) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
                digging <= 1'b0;
                aaah <= 1'b0;
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 5'b10100) begin // 20 clock cycles
                        state <= SPLATTERED;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        state <= WALKING;
                        if (walk_dir) begin
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                        end else begin
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                        end
                        digging <= 1'b0;
                        aaah <= 1'b0;
                    end
                end else begin
                    fall_count <= fall_count + 1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    digging <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                end
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