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

    reg [1:0] state; // 00: left, 01: right, 10: falling

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // start walking left
        end
        else begin
            case (state)
                2'b00: state <= (!ground) ? 2'b10 : (bump_left ? 2'b01 : 2'b00);
                2'b01: state <= (!ground) ? 2'b10 : (bump_right ? 2'b00 : 2'b01);
                2'b10: state <= (ground) ? state[1:0] : 2'b10; // maintain direction when ground returns
                default: state <= 2'b00;
            endcase
        end
    end

    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = (state == 2'b10);

endmodule