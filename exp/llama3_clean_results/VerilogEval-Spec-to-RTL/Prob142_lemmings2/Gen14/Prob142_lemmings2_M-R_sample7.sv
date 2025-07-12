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

// State encoding: 2'b00 - walking left, 2'b01 - walking right, 2'b10 - falling left, 2'b11 - falling right
reg [1:0] state;

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        case(state)
            2'b00: // walking left
                if (~ground) begin
                    state <= 2'b10; // falling left
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                end
            2'b01: // walking right
                if (~ground) begin
                    state <= 2'b11; // falling right
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                end
            2'b10: // falling left
                if (ground) begin
                    state <= 2'b00; // walking left
                end
            2'b11: // falling right
                if (ground) begin
                    state <= 2'b01; // walking right
                end
        endcase
    end
end

// Output logic
assign walk_left = (state == 2'b00)? 1'b1 : (bump_right && state == 2'b01)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01)? 1'b1 : (bump_left && state == 2'b00)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10 || state == 2'b11)? 1'b1 : 1'b0;

endmodule