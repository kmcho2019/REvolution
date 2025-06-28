module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);
  
  reg [3:0] state;
  reg [7:0] data_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 4'b0000;
      data_reg <= 8'b0;
      out_byte <= 8'b0;
      done <= 1'b0;
    end
    else begin
      case (state)
        4'b0000: begin // Idle state, waiting for start bit
          if (in == 1'b0) begin
            state <= 4'b0001; // Transition to start bit detected state
          end
        end
        4'b0001: begin // Start bit detected, receive 8 data bits
          data_reg <= {in, data_reg[7:1]};
          state <= 4'b0010; // Transition to data bit reception
        end
        4'b0010: begin // Data bit reception
          data_reg <= {in, data_reg[7:1]};
          if ($rose(clk)) begin // Check on rising clock edge
            state <= (state == 4'b1000) ? 4'b1001 : state + 1;
          end
        end
        4'b1001: begin // Stop bit expected
          if (in == 1'b1) begin
            out_byte <= data_reg;
            done <= 1'b1;
            state <= 4'b0000; // Transition to idle state
          end
        end
      endcase
    end
  end

endmodule