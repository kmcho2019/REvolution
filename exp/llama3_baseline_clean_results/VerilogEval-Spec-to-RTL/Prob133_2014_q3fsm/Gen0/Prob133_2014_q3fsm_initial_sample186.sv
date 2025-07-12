module TopModule(clk, reset, s, w, z);
  input clk, reset, s, w;
  output z;

  reg [1:0] state; // 0: A, 1: B, 2: set_z
  reg [2:0] w_count; // count of w = 1 occurrences
  reg [1:0] cycle_count; // count of clock cycles

  always @(posedge clk) begin
    if (reset) begin
      state <= 0; // reset state A
      w_count <= 0;
      cycle_count <= 0;
      z <= 0;
    end
    else begin
      case (state)
        0: begin // state A
          if (s) begin
            state <= 1; // transition to state B
            w_count <= 0;
            cycle_count <= 0;
          end
        end
        1: begin // state B
          if (w) begin
            w_count <= w_count + 1;
          end
          cycle_count <= cycle_count + 1;
          if (cycle_count == 3) begin
            if (w_count == 2) begin
              state <= 2; // set_z state
            end
            else begin
              w_count <= 0;
              cycle_count <= 0;
            end
          end
        end
        2: begin // set_z state
          z <= 1;
          state <= 1; // back to state B
          w_count <= 0;
          cycle_count <= 0;
        end
      endcase
    end
  end

  always @(*) begin
    if (state != 2) begin
      z = 0;
    end
  end

endmodule