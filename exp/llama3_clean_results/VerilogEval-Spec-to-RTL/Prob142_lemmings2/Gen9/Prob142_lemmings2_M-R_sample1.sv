module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;
    case(state)
        2'b00: // walking left
            begin
                if (~ground) begin
                    next_state = 2'b10; // falling
                end else if (bump_left || bump_right) begin
                    next_state = 2'b01; // walking right
                end
            end
        2'b01: // walking right
            begin
                if (~ground) begin
                    next_state = 2'b10; // falling
                end else if (bump_left || bump_right) begin
                    next_state = 2'b00; // walking left
                end
            end
        2'b10: // falling
            begin
                if (ground) begin
                    next_state = (bump_left || bump_right) ? (state == 2'b00) ? 2'b01 : 2'b00 : state == 2'b00 ? 2'b00 : 2'b01; // walking
                end
            end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b10) ? 1'b1 : 1'b0;

endmodule