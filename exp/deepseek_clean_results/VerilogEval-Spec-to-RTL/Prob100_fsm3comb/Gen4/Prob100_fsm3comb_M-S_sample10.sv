module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case (state)
        2'b00: begin out = 1'b0; next_state = in ? 2'b01 : 2'b00; end // State A
        2'b01: begin out = 1'b0; next_state = in ? 2'b01 : 2'b10; end // State B
        2'b10: begin out = 1'b0; next_state = in ? 2'b11 : 2'b00; end // State C
        2'b11: begin out = 1'b1; next_state = in ? 2'b01 : 2'b10; end // State D
    endcase
end

endmodule