module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 2-bit state register
reg [1:0] prev_state; // previous walking state

// output signals
assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b11);

// state transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // initial state: walking left
        prev_state <= 2'b00;
    end else begin
        case (state)
            2'b00: // walking left
                if (~ground) begin
                    state <= 2'b11; // falling
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                end
            2'b01: // walking right
                if (~ground) begin
                    state <= 2'b11; // falling
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                end
            2'b11: // falling
                if (ground) begin
                    state <= prev_state; // resume walking
                end
            default: state <= 2'b00;
        endcase
        if (state != 2'b11) begin
            prev_state <= state;
        end
    end
end

endmodule