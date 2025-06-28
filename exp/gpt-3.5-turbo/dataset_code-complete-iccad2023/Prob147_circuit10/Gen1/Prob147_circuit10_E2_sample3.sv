module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state, current_state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always @(posedge clk) begin
    current_state <= next_state;
end

always @* begin
    case (current_state)
        S0: begin
            if (a & ~b)
                next_state = S1;
            else
                next_state = S0;
            q = 1'b0;
            state = 1'b0;
        end
        S1: begin
            if (~a | b)
                next_state = S2;
            else
                next_state = S1;
            q = 1'b0;
            state = 1'b0;
        end
        S2: begin
            if (~a & ~b)
                next_state = S3;
            else
                next_state = S2;
            q = 1'b1;
            state = 1'b0;
        end
        S3: begin
            if (a | ~b)
                next_state = S0;
            else
                next_state = S3;
            q = 1'b1;
            state = 1'b1;
        end
        default: next_state = S0;
    endcase
end

initial begin
    current_state = S0;
    next_state = S0;
end

endmodule