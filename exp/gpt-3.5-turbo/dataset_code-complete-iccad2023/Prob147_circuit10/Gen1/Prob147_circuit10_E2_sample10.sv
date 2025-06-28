module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state;
reg [1:0] next_state;

 always @(posedge clk) begin
    state <= next_state[1];
    q <= next_state[0];
    current_state <= next_state;
 end

 always @(*) begin
    case (current_state)
        2'b00: begin
           if (a & !b)
              next_state = 2'b01;
           else
              next_state = 2'b00;
        end

        2'b01: begin
           if (a & b)
              next_state = 2'b10;
           else
              next_state = 2'b01;
        end

        2'b10: begin
           if (!a & b)
              next_state = 2'b11;
           else
              next_state = 2'b10;
        end

        2'b11: begin
           if (a & b)
              next_state = 2'b00;
           else
              next_state = 2'b11;
        end
    endcase
 end

endmodule