module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case ({state, in})
        3'b000, 3'b100: begin next_state = 2'b00; out = 1'b0; end
        3'b001, 3'b101: begin next_state = 2'b01; out = 1'b0; end
        3'b010: begin next_state = 2'b10; out = 1'b0; end
        3'b011: begin next_state = 2'b11; out = 1'b0; end
        3'b110: begin next_state = 2'b00; out = 1'b0; end
        3'b111: begin next_state = 2'b01; out = 1'b1; end
        default: begin next_state = 2'b00; out = 1'b0; end
    endcase
end

endmodule