module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: next_state = in ? 2'b01 : 2'b00;
        2'b01: next_state = in ? 2'b01 : 2'b10;
        2'b10: next_state = in ? 2'b11 : 2'b00;
        2'b11: next_state = in ? 2'b01 : 2'b10;
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule