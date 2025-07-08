module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
      ena <= 3'b0;
    end else begin
      ena <= 3'b0;

      // Increment ones digit
      if (q[3:0] == 4'd9) begin
        q[3:0] <= 4'd0;
        // Enable tens digit increment
        ena[1] <= 1'b1;
        if (q[7:4] == 4'd9) begin
          q[7:4] <= 4'd0;
          // Enable hundreds digit increment
          ena[2] <= 1'b1;
          if (q[11:8] == 4'd9) begin
            q[11:8] <= 4'd0;
            // Enable thousands digit increment
            ena[3] <= 1'b1;
            if (q[15:12] == 4'd9) begin
              q[15:12] <= 4'd0; // roll over after 9999
            end else begin
              q[15:12] <= q[15:12] + 4'd1;
            end
          end else begin
            q[11:8] <= q[11:8] + 4'd1;
          end
        end else begin
          q[7:4] <= q[7:4] + 4'd1;
        end
      end else begin
        q[3:0] <= q[3:0] + 4'd1;
      end
    end
  end

endmodule