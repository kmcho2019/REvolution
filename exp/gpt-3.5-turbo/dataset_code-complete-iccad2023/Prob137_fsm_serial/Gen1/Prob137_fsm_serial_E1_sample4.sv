module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define states
localparam IDLE = 2'd0;
localparam DETECT_START = 2'd1;
localparam COLLECT_DATA = 2'd2;
localparam VERIFY_STOP = 2'd3;

// Registers
reg [1:0] state;
reg [2:0] count;
reg [7:0] data_reg;
reg start_detected;

// Combinational logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    count <= 0;
    data_reg <= 8'h00;
    done <= 0;
    start_detected <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (!in && !start_detected) begin
          state <= DETECT_START;
          start_detected <= 1;
        end else begin
          start_detected <= 0;
        end
      end
      DETECT_START: begin
        if (count < 9) begin // Wait for full start bit
          if (!in) begin
            count <= count + 1;
          end else begin
            count <= 0;
            state <= IDLE; // False start bit, go back to idle
          end
        end else begin
          count <= 0;
          state <= COLLECT_DATA;
        end
      end
      COLLECT_DATA: begin
        if (count < 8) begin
          data_reg <= {data_reg[6:0], in};
          count <= count + 1;
        end else begin
          count <= 0;
          state <= VERIFY_STOP;
        end
      end
      VERIFY_STOP: begin
        if (count == 0) begin
          if (in) begin
            done <= 1; // Correct stop bit received
          end else begin
            state <= IDLE; // Incorrect stop bit, go back to idle
          end
        end
        count <= count + 1;
      end
    endcase
  end
end

endmodule