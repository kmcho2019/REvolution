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
            if (a == 0 && b == 0) begin
                next_state = 0;
                q = 0;
            end else if (a == 0 && b == 1) begin
                next_state = 0;
                q = 1;
            end else if (a == 1 && b == 0) begin
                next_state = 0;
                q = 1;
            end else if (a == 1 && b == 1) begin
                next_state = 1;
                q = 1;
            end
            state = next_state;
        end
        1: begin
            if (a == 1 && b == 1) begin
                next_state = 1;
                q = 1;
            end else begin
                next_state = 0;
                q = 0;
            end
            state = next_state;
        end
        default: begin
            next_state = 0;
            q = 0;
            state = 0;
        end
    endcase
end

endmodule