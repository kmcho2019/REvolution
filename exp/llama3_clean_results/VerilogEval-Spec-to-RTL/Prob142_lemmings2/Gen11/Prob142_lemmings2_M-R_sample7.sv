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

reg [3:0] state; // one-hot encoding: walking_left, walking_right, falling_left, falling_right

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b1000; // reset to walking_left
    end else begin
        case(state)
            4'b1000: // walking_left
                begin
                    if (~ground) begin
                        state <= 4'b0010; // falling_left
                    end else if (bump_left) begin
                        state <= 4'b0100; // walking_right
                    end else if (bump_right) begin
                        // do nothing, keep walking_left
                    end
                end
            4'b0100: // walking_right
                begin
                    if (~ground) begin
                        state <= 4'b0001; // falling_right
                    end else if (bump_right) begin
                        state <= 4'b1000; // walking_left
                    end else if (bump_left) begin
                        // do nothing, keep walking_right
                    end
                end
            4'b0010: // falling_left
                begin
                    if (ground) begin
                        state <= 4'b1000; // walking_left
                    end
                end
            4'b0001: // falling_right
                begin
                    if (ground) begin
                        state <= 4'b0100; // walking_right
                    end
                end
        endcase
    end
end

// Output logic
assign walk_left = state[3]; // walking_left
assign walk_right = state[2]; // walking_right
assign aaah = state[1] | state[0]; // falling_left or falling_right

endmodule