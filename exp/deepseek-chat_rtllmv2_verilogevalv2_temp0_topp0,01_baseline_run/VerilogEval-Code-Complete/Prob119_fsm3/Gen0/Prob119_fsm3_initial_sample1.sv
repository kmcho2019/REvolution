module TopModule (
  input clk,
  input in,
  input areset,
  output out
);

  // Define states
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  // State register
  reg [1:0] state;

  // State transition and reset logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
    end else begin
      case (state)
        A: state <= in ? B : A;
        B: state <= in ? B : C;
        C: state <= in ? D : A;
        D: state <= in ? B : C;
      endcase
    end
  end

  // Output logic (Moore: output depends only on state)
  assign out = (state == D) ? 1'b1 : 1'b0;

endmodule