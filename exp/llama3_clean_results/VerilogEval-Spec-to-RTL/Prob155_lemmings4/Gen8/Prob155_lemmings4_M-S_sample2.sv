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

reg [2:0] state; // 3'b000: walking, 3'b001: falling, 3'b010: splattered
reg [4:0] fall_counter;
reg walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000;
        fall_counter <= 5'b0;
        walk_direction <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // walking
                if (~ground) begin
                    state <= 3'b001;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    digging <= 1'b1;
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                    if (walk_direction) begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                end
            end
            3'b001: begin // falling
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3'b010;
                    end else begin
                        state <= 3'b000;
                        fall_counter <= 5'b0;
                    end
                end
            end
            3'b010: begin // splattered
                // do nothing
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    if (state == 3'b001) begin
        aaah = 1'b1;
    end else begin
        aaah = 1'b0;
    end
end

endmodule