module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
    case({state, a, b})
        3'b000: begin // State 0, a=0, b=0
            next_state = 3'b000;
            q = 1'b0;
        end
        3'b001: begin // State 0, a=0, b=1
            next_state = 3'b000;
            q = 1'b1;
        end
        3'b010: begin // State 0, a=1, b=0
            next_state = 3'b000;
            q = 1'b1;
        end
        3'b011: begin // State 0, a=1, b=1
            next_state = 3'b001;
            q = 1'b1;
        end
        3'b100: begin // State 1, a=0, b=0
            next_state = 3'b100;
            q = 1'b0;
        end
        3'b101: begin // State 1, a=0, b=1
            next_state = 3'b100;
            q = 1'b1;
        end
        3'b110: begin // State 1, a=1, b=0
            next_state = 3'b100;
            q = 1'b1;
        end
        3'b111: begin // State 1, a=1, b=1
            next_state = 3'b000;
            q = 1'b1;
        end
        default: begin
            next_state = 3'b000;
            q = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule