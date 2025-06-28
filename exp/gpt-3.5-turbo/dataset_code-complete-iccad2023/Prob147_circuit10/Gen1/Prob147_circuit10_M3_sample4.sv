module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state, next_state;

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @(posedge clk) begin
    current_state <= next_state;
end

always @* begin
    case (current_state)
        S0: next_state = (a) ? S1 : S0;
        S1: next_state = (b) ? S2 : S1;
        S2: next_state = (~a) ? S3 : S2;
        S3: next_state = (~b) ? S0 : S3;
        default: next_state = S0;
    endcase
end

always @(posedge clk) begin
    q <= (current_state == S1);
    state <= (current_state == S3);
end

endmodule