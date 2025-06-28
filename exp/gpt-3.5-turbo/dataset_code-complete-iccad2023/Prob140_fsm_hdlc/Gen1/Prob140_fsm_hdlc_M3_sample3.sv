module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  reg [2:0] state;
  reg [5:0] ones_counter;

  // Initializing the FSM
  always @(posedge clk or posedge reset)
  begin
    if (reset) begin
      state <= 3'b000;
      ones_counter <= 6'b0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end
    else begin
      case (state)
        3'b000: begin // State 0: Looking for 0111110
          if (in) begin
            ones_counter <= ones_counter + 1;
            if (ones_counter == 6'b0111110) begin
              ones_counter <= 6'b0;
              disc <= 1;
              state <= 3'b000;
            end
            else begin
              disc <= 0;
              state <= 3'b001;
            end
          end
          else begin
            ones_counter <= 6'b0;
            disc <= 0;
          end
        end
        3'b001: begin // State 1: Looking for 01111110
          if (in) begin
            ones_counter <= ones_counter + 1;
            if (ones_counter == 7'b01111110) begin
              ones_counter <= 6'b0;
              flag <= 1;
              state <= 3'b000;
            end
            else begin
              flag <= 0;
              state <= 3'b002;
            end
          end
          else begin
            ones_counter <= 6'b0;
            flag <= 0;
            state <= 3'b000;
          end
        end
        3'b002: begin // State 2: Detecting error
          if (in) begin
            ones_counter <= ones_counter + 1;
            if (ones_counter >= 7) begin
              ones_counter <= 6'b0;
              err <= 1;
              state <= 3'b000;
            end
            else begin
              err <= 0;
            end
          end
          else begin
            ones_counter <= 6'b0;
            err <= 0;
            state <= 3'b000;
          end
        end
      endcase
    end
  end

endmodule