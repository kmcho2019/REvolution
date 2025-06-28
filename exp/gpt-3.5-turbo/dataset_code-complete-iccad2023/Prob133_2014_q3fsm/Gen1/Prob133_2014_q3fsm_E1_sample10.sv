module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state;
  
  reg [1:0] w_count;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      w_count <= 2'b00;
      z <= 0;
    end else begin
      case (state)
        2'b00: begin // State A
          if (s == 1) begin
            state <= 2'b01; // Move to State B
          end else begin
            state <= 2'b00; // Stay in State A
          end
        end
        2'b01: begin // State B
          if (w == 1) begin
            w_count <= w_count + 1;
          end
          if (w_count == 3) begin
            if (w_count == 2) begin
              z <= 1;
            end else begin
              z <= 0;
            end
            w_count <= 2'b00; // Reset w_count for the next set of 3 clock cycles
            state <= 2'b00; // Move back to State A
          end else begin
            state <= 2'b01; // Stay in State B
          end
        end
        default: state <= 2'b00; // Default to State A
      endcase
    end
  end
endmodule