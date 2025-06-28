module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state, current_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @* begin
    case (current_state)
        0: begin
            next_state = (a & ~b);
            q <= next_state;
            state <= 0;
        end
        1: begin
            next_state = ~(a | b);
            q <= next_state;
            state <= 1;
        end
        default: begin
            next_state = 0;
            q <= next_state;
            state <= 0;
        end
    endcase
end

endmodule