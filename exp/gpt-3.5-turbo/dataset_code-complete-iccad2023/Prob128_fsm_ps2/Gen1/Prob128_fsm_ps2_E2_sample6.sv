module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

// Define signals
reg [1:0] state, next_state;
reg [1:0] byte_count;

// State transition and outputs
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    byte_count <= 2'b00;
    done <= 0;
  end else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;
  
  case(state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
        byte_count <= 2'b01;
      end
    end

    BYTE1: begin
      if(byte_count == 2'b10)
        next_state = BYTE2;
      byte_count <= byte_count + 1;
    end

    BYTE2: begin
      if(byte_count == 2'b11)
        next_state = BYTE3;
      byte_count <= byte_count + 1;
    end

    BYTE3: begin
      if(byte_count == 2'b00) begin
        next_state = IDLE;
        done <= 1;
      end
      byte_count <= byte_count + 1;
    end
  endcase
end

endmodule