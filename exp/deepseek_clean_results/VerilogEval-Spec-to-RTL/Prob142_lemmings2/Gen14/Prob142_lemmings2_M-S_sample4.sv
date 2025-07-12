module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    reg [1:0] state;  // 00: walk left, 01: walk right, 10: fall left, 11: fall right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= (~ground) ? 2'b10 : (bump_left ? 2'b01 : 2'b00);
                2'b01: state <= (~ground) ? 2'b11 : (bump_right ? 2'b00 : 2'b01);
                2'b10: state <= (ground) ? 2'b00 : 2'b10;
                2'b11: state <= (ground) ? 2'b01 : 2'b11;
            endcase
        end
    end

    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = state[1];

endmodule