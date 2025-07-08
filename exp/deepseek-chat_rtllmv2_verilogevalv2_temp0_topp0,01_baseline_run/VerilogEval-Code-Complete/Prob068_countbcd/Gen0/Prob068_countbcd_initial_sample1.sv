module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  // Enable signals
  assign ena[1] = 1'b1;  // Always enable ones digit
  assign ena[2] = (q[3:0] == 4'd9);  // Enable tens when ones is 9
  assign ena[3] = (q[7:4] == 4'd9) && (q[3:0] == 4'd9);  // Enable hundreds when tens and ones are 9

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
    end else begin
      // Ones digit (always increments)
      if (q[3:0] == 4'd9) begin
        q[3:0] <= 4'd0;
      end else begin
        q[3:0] <= q[3:0] + 1'd1;
      end

      // Tens digit (increments when ones wraps)
      if (ena[2]) begin
        if (q[7:4] == 4'd9) begin
          q[7:4] <= 4'd0;
        end else begin
          q[7:4] <= q[7:4] + 1'd1;
        end
      end

      // Hundreds digit (increments when tens wraps)
      if (ena[3]) begin
        if (q[11:8] == 4'd9) begin
          q[11:8] <= 4'd0;
        end else begin
          q[11:8] <= q[11:8] + 1'd1;
        end
      end

      // Thousands digit (increments when hundreds wraps)
      if (ena[3] && (q[11:8] == 4'd9)) begin
        if (q[15:12] == 4'd9) begin
          q[15:12] <= 4'd0;
        end else begin
          q[15:12] <= q[15:12] + 1'd1;
        end
      end
    end
  end

endmodule