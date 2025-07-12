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
reg [1:0] state; // 2'b00: walking, 2'b01: falling, 2'b10: splattered
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right
reg is_digging;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking
                if (~ground) begin
                    state <= 2'b01;
                    fall_counter <= 5'b1;
                    is_digging <= 1'b0;
                end else if (dig && !is_digging) begin
                    is_digging <= 1'b1;
                end else if (bump_left || bump_right) begin
                    direction <= ~direction;
                    is_digging <= 1'b0;
                end
            end
            2'b01: begin // falling
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b10;
                    end else begin
                        state <= 2'b00;
                        fall_counter <= 5'b0;
                        is_digging <= 1'b0;
                    end
                end
            end
            2'b10: begin // splattered
                // do nothing
            end
        endcase
    end
end

// Combinational logic
assign walk_left = (state == 2'b00) && !direction && !is_digging && (state != 2'b10) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b00) && direction && !is_digging && (state != 2'b10) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b01) && (state != 2'b10) ? 1'b1 : 1'b0;
assign digging = (state == 2'b00) && is_digging && (state != 2'b10) ? 1'b1 : 1'b0;

endmodule