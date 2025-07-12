module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    // synthesis parallel_case
    case (state)
        2'b00: begin next_state = in ? 2'b01 : 2'b00; out = 1'b0; end // A
        2'b01: begin next_state = in ? 2'b01 : 2'b10; out = 1'b0; end // B
        2'b10: begin next_state = in ? 2'b11 : 2'b00; out = 1'b0; end // C
        2'b11: begin next_state = in ? 2'b01 : 2'b10; out = 1'b1; end // D
    endcase
end

endmodule