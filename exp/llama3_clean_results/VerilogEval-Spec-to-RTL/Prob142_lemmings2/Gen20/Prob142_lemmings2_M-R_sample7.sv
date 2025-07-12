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

reg [1:0] state; // 2-bit state register (00: left, 01: right, 10: falling)

// Sequential logic and output logic combined
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to left
    end else begin
        case (state)
            2'b00: begin // left
                if (~ground) begin
                    state <= 2'b10; // falling
                end else if (bump_right) begin
                    state <= 2'b01; // change direction to right
                end
            end
            2'b01: begin // right
                if (~ground) begin
                    state <= 2'b10; // falling
                end else if (bump_left) begin
                    state <= 2'b00; // change direction to left
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    state <= state[0] ? 2'b01 : 2'b00; // resume walking
                end
            end
        endcase
    end
end

// Output logic using assign statements
assign walk_left = ~state[1] & ~state[0];
assign walk_right = ~state[1] & state[0];
assign aaah = state[1];

endmodule