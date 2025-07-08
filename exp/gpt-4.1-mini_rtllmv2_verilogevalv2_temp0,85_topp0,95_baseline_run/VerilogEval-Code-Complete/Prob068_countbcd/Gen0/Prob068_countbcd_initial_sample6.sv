module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  // Extract digits from q
  wire [3:0] ones   = q[3:0];
  wire [3:0] tens   = q[7:4];
  wire [3:0] hundreds = q[11:8];
  wire [3:0] thousands = q[15:12];

  // ena signals indicate when to increment next digit
  // ena[1]: increment tens when ones rolls over from 9 to 0
  // ena[2]: increment hundreds when tens rolls over
  // ena[3]: increment thousands when hundreds rolls over
  assign ena[1] = (ones == 4'd9);
  assign ena[2] = (tens == 4'd9) && ena[1];
  assign ena[3] = (hundreds == 4'd9) && ena[2];

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
    end else begin
      // Start with ones digit incremented
      if (ones == 4'd9) begin
        // ones rolls over to 0
        q[3:0] <= 4'd0;
        // increment tens digit if enabled
        if (ena[1]) begin
          if (tens == 4'd9) begin
            q[7:4] <= 4'd0;
            // increment hundreds if enabled
            if (ena[2]) begin
              if (hundreds == 4'd9) begin
                q[11:8] <= 4'd0;
                // increment thousands if enabled
                if (ena[3]) begin
                  if (thousands == 4'd9) begin
                    q[15:12] <= 4'd0; // roll over after 9999
                  end else begin
                    q[15:12] <= thousands + 1;
                  end
                end
              end else begin
                q[11:8] <= hundreds + 1;
              end
            end
          end else begin
            q[7:4] <= tens + 1;
          end
        end
      end else begin
        // Just increment ones digit
        q[3:0] <= ones + 1;
      end
    end
  end

endmodule