module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// State definition
parameter IDLE = 2'd0;
parameter RECEIVING = 2'd1;
parameter DONE = 2'd2;

reg [1:0] state;
reg [2:0] data_counter;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_counter <= 0;
    data <= 0;
    out_byte <= 8'b0;
    done <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (!in) begin
          state <= RECEIVING;
          data_counter <= 0;
        end
      end
      RECEIVING: begin
        if (data_counter < 8) begin
          data <= {data[6:0], in};
          data_counter <= data_counter + 1;
          if (data_counter == 7) begin
            state <= DONE;
          end
        end
      end
      DONE: begin
        if (in) begin
          out_byte <= data;
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule