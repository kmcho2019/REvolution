module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

// state transition logic
always @* begin
  case(state)
    4'b0001: next_state = in ? 4'b0010 : 4'b0001; // A
    4'b0010: next_state = in ? 4'b0100 : 4'b0010; // B
    4'b0100: next_state = in ? 4'b0001 : 4'b1000; // C
    4'b1000: next_state = in ? 4'b0100 : 4'b0010; // D
    default: next_state = 4'bxxxx; // should not occur
  endcase
end

// output logic
assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule