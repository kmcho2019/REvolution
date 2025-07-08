module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);
  // Extract individual digits for clarity
  wire [3:0] d0 = q[3:0];
  wire [3:0] d1 = q[7:4];
  wire [3:0] d2 = q[11:8];
  wire [3:0] d3 = q[15:12];

  reg [3:0] next_d0, next_d1, next_d2, next_d3;
  reg ena1, ena2, ena3;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
      ena <= 3'd0;
    end else begin
      // Increment ones digit
      if (d0 == 4'd9) begin
        next_d0 = 4'd0;
        ena1 = 1'b1; // Enable tens digit
      end else begin
        next_d0 = d0 + 1;
        ena1 = 1'b0;
      end

      // Increment tens digit if enabled
      if (ena1) begin
        if (d1 == 4'd9) begin
          next_d1 = 4'd0;
          ena2 = 1'b1; // Enable hundreds digit
        end else begin
          next_d1 = d1 + 1;
          ena2 = 1'b0;
        end
      end else begin
        next_d1 = d1;
        ena2 = 1'b0;
      end

      // Increment hundreds digit if enabled
      if (ena2) begin
        if (d2 == 4'd9) begin
          next_d2 = 4'd0;
          ena3 = 1'b1; // Enable thousands digit
        end else begin
          next_d2 = d2 + 1;
          ena3 = 1'b0;
        end
      end else begin
        next_d2 = d2;
        ena3 = 1'b0;
      end

      // Increment thousands digit if enabled
      if (ena3) begin
        if (d3 == 4'd9) begin
          next_d3 = 4'd0; // Roll over after 9999 to 0000
        end else begin
          next_d3 = d3 + 1;
        end
      end else begin
        next_d3 = d3;
      end

      q <= {next_d3, next_d2, next_d1, next_d0};
      ena <= {ena3, ena2, ena1};
    end
  end
endmodule