module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output done
);

  reg [2:0] state;
  reg [7:0] data_reg;
  reg [3:0] bit_count;
  
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      data_reg <= 8'b0;
      bit_count <= 4'd0;
    end
    else begin
      case (state)
        3'b000: begin // IDLE state
          if (in == 1'b0) begin
            state <= 3'b001; // Transition to RECEIVING on start bit
            bit_count <= 4'd0; // Reset bit count
          end
        end
        3'b001: begin // RECEIVING state
          if (bit_count < 8) begin
            data_reg <= {data_reg[6:0], in}; // Shift in the incoming data bit
            bit_count <= bit_count + 1; // Increment bit count
          end
          else begin
            state <= 3'b010; // Transition to STOP_BIT after 8 data bits
            bit_count <= 4'd0; // Reset bit count
          end
        end
        3'b010: begin // STOP_BIT state
          if (in == 1'b1) begin
            out_byte <= data_reg; // Output received byte
            state <= 3'b000; // Transition back to IDLE
            done <= 1; // Assert done
          end
          else begin
            // Wait for stop bit by staying in this state
          end
        end
      endcase
    end
  end

endmodule