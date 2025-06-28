module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

  reg [1:0] stage; // 2-stage shift register

  always @(posedge clk) begin
    if (L) begin // Load value from R
      stage <= {R, w};
    end else if (E) begin // Enable shifting
      stage <= {stage[0], w};
    end else begin
      stage <= stage; // Maintain current value if no operation
    end
  end

  assign Q = stage[1]; // Output from the second stage

endmodule