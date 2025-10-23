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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg prev_ground; // previous value of ground

// Sequential logic to update the state and previous ground
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        prev_ground <= 1'b1; // reset previous ground to 1
    end else begin
        case (state)
            2'b00: // walking left
                if (ground == 1'b0) begin
                    state <= 2'b10; // falling
                end else if (bump_left || bump_right) begin
                    state <= 2'b01; // walking right
                end
            2'b01: // walking right
                if (ground == 1'b0) begin
                    state <= 2'b10; // falling
                end else if (bump_left || bump_right) begin
                    state <= 2'b00; // walking left
                end
            2'b10: // falling
                if (ground == 1'b1) begin
                    if (prev_ground == 1'b0) begin
                        state <= 2'b00; // resume walking left
                    end else if (state == 2'b10) begin
                        if (bump_left || bump_right) begin
                            state <= 2'b01; // resume walking right
                        end else begin
                            state <= 2'b00; // resume walking left
                        end
                    end
                end
        endcase
        if (ground == 1'b0) begin
            prev_ground <= ground;
        end else if (prev_ground == 1'b0 && ground == 1'b1) begin
            prev_ground <= ground;
        end
    end
end

// Output logic
assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);

endmodule