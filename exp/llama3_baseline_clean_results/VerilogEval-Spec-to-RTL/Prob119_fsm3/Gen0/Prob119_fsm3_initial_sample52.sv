module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: next_state = (in) ? 2'b01 : 2'b00;  // State A
        2'b01: next_state = (in) ? 2'b01 : 2'b10;  // State B
        2'b10: next_state = (in) ? 2'b11 : 2'b00;  // State C
        2'b11: next_state = (in) ? 2'b01 : 2'b10;  // State D
        default: next_state = 2'b00;
    endcase
end

always @(*) begin
    case(state)
        2'b00: out = 1'b0;  // State A
        2'b01: out = 1'b0;  // State B
        2'b10: out = 1'b0;  // State C
        2'b11: out = 1'b1;  // State D
        default: out = 1'b0;
    endcase
end

endmodule