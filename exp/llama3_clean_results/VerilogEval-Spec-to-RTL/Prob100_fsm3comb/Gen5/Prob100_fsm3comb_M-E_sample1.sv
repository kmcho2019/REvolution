module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state logic using LUTs
always @(*) begin
    case ({state, in})
        3'b000: next_state = 2'b00; out = 1'b0;
        3'b001: next_state = 2'b01; out = 1'b0;
        3'b010: next_state = 2'b10; out = 1'b0;
        3'b011: next_state = 2'b01; out = 1'b0;
        3'b100: next_state = 2'b00; out = 1'b0;
        3'b101: next_state = 2'b11; out = 1'b0;
        3'b110: next_state = 2'b10; out = 1'b1;
        3'b111: next_state = 2'b01; out = 1'b1;
        default: next_state = 2'b00; out = 1'b0;
    endcase
end

endmodule