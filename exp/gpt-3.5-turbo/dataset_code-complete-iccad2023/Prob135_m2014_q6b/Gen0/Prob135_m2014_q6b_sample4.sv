module next_state_logic (
  input [3:1] y,
  input w,
  output reg Y2
);

always @(*) begin
    case(y)
        3'b000: Y2 = (w) ? 0 : 1; // A
        3'b001: Y2 = (w) ? 0 : 1; // B
        3'b010: Y2 = (w) ? 0 : 1; // C
        3'b011: Y2 = (w) ? 1 : 0; // D
        3'b100: Y2 = (w) ? 1 : 0; // E
        3'b101: Y2 = (w) ? 1 : 0; // F
        default: Y2 = 1'b0;
    endcase
end

endmodule