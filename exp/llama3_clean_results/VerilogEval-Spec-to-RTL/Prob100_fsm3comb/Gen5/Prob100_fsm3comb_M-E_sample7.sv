module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case({state, in})
        3'b000: begin next_state = 2'b00; out = 1'b0; end // State A, in = 0
        3'b001: begin next_state = 2'b01; out = 1'b0; end // State A, in = 1
        3'b010: begin next_state = 2'b10; out = 1'b0; end // State B, in = 0
        3'b011: begin next_state = 2'b01; out = 1'b0; end // State B, in = 1
        3'b100: begin next_state = 2'b00; out = 1'b0; end // State C, in = 0
        3'b101: begin next_state = 2'b11; out = 1'b0; end // State C, in = 1
        3'b110: begin next_state = 2'b10; out = 1'b1; end // State D, in = 0
        3'b111: begin next_state = 2'b01; out = 1'b1; end // State D, in = 1
        default: begin next_state = 2'b00; out = 1'b0; end // Invalid state
    endcase
end

endmodule