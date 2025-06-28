module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter WAITING = 2'b00;

// Define signals
reg [1:0] state = WAITING;
reg [1:0] byte_count = 2'b00;

// State and output logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= WAITING;
    byte_count <= 2'b00;
    done <= 0;
  end else begin
    case(state)
      WAITING: begin
        if (in[3] == 1) begin
          byte_count <= byte_count + 1;
          if (byte_count == 2 && in[3] == 1) begin
            done <= 1;
            byte_count <= 2'b00;
          end
        end else begin
          byte_count <= 2'b00;
        end
      end
    endcase
  end
end

endmodule