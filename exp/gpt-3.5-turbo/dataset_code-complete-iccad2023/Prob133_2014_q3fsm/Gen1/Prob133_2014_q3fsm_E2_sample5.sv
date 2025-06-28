module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  parameter A = 2'b00;
  parameter B = 2'b01;
  
  // State and sub-state registers
  reg [1:0] state, next_state;
  reg [1:0] b_state;
  
  // Count of 'w' being 1
  reg count_w;
  
  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
    end else begin
      state <= next_state;
      case(state)
        A: begin
             if (s == 1) begin
               next_state = B;
               count_w <= 0;
             end else begin
               next_state = A;
             end
           end
        B: begin
             case (b_state)
               2'b00: begin // Clock cycle 1
                        if (w == 1) begin
                          count_w <= count_w + 1;
                        end
                        b_state <= 2'b01;
                      end
               2'b01: begin // Clock cycle 2
                        if (w == 1) begin
                          count_w <= count_w + 1;
                        end
                        b_state <= 2'b10;
                      end
               2'b10: begin // Clock cycle 3
                        if (w == 1) begin
                          count_w <= count_w + 1;
                        end
                        if (count_w == 2) begin
                          z <= 1;
                        end else begin
                          z <= 0;
                        end
                        count_w <= 0;
                        b_state <= 2'b00;
                      end
               default: b_state <= 2'b00;
             endcase
             next_state = B;
           end
        default: next_state = A;
      endcase
    end
  end
endmodule