module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state, next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @* begin
    case (current_state)
        2'b00: begin
            if (a == 1'b0 && b == 1'b0)
                next_state = 2'b00;
            else if (a == 1'b0 && b == 1'b1)
                next_state = 2'b01;
            else
                next_state = 2'b00;
            q = 1'b0;
            state = 1'b0;
        end
        2'b01: begin
            next_state = (a == 1'b1 && b == 1'b1) ? 2'b10 : 2'b01;
            q = 1'b1;
            state = 1'b0;
        end
        2'b10: begin
            next_state = (a == 1'b1 && b == 1'b0) ? 2'b11 : 2'b10;
            q = 1'b0;
            state = 1'b1;
        end
        2'b11: begin
            next_state = (a == 1'b1 && b == 1'b1) ? 2'b01 : 2'b11;
            q = 1'b1;
            state = 1'b1;
        end
        default: begin
            next_state = 2'b00;
            q = 1'b0;
            state = 1'b0;
        end
    endcase
end

endmodule