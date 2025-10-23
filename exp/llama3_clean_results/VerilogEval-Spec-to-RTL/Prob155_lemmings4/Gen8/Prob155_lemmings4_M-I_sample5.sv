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

// Define states
reg [2:0] state; // 3'b000: walking left, 3'b001: walking right, 3'b010: falling, 3'b011: digging, 3'b100: splattered
reg [4:0] fall_counter;
reg walk_dir; // 1'b0: left, 1'b1: right

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000;
        fall_counter <= 5'b0;
        walk_dir <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // walking left
                if (~ground) begin
                    state <= 3'b010;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= 3'b011;
                end else if (bump_left || bump_right) begin
                    state <= 3'b001;
                    walk_dir <= 1'b1;
                end
            end
            3'b001: begin // walking right
                if (~ground) begin
                    state <= 3'b010;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= 3'b011;
                end else if (bump_left || bump_right) begin
                    state <= 3'b000;
                    walk_dir <= 1'b0;
                end
            end
            3'b010: begin // falling
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3'b100;
                    end else begin
                        state <= walk_dir ? 3'b001 : 3'b000;
                        fall_counter <= 5'b0;
                    end
                end
            end
            3'b011: begin // digging
                if (~ground) begin
                    state <= 3'b010;
                    fall_counter <= 5'b1;
                end
            end
            3'b100: begin // splattered
                // do nothing
            end
        endcase
    end
end

// Combinational logic
assign walk_left = (state == 3'b000 && !walk_dir) ? 1'b1 : (state == 3'b010) ? 1'b0 : (state == 3'b001 && !walk_dir) ? 1'b1 : 1'b0;
assign walk_right = (state == 3'b001 && walk_dir) ? 1'b1 : (state == 3'b010) ? 1'b0 : (state == 3'b000 && walk_dir) ? 1'b1 : 1'b0;
assign aaah = (state == 3'b010) ? 1'b1 : 1'b0;
assign digging = (state == 3'b011) ? 1'b1 : 1'b0;

endmodule