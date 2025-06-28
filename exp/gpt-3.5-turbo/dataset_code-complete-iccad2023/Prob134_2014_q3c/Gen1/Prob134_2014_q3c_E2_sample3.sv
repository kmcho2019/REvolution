module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @ (*) begin
    case({y, x})
        3'b0000: begin // Present state 000, x=0
            Y0 <= 1'b0;
            z <= 1'b0;
        end
        3'b0001: begin // Present state 000, x=1
            Y0 <= 1'b0;
            z <= 1'b0;
        end
        3'b0010: begin // Present state 001, x=0
            Y0 <= 1'b0;
            z <= 1'b0;
        end
        3'b0011: begin // Present state 001, x=1
            Y0 <= 1'b0;
            z <= 1'b1;
        end
        3'b0100: begin // Present state 010, x=0
            Y0 <= 1'b1;
            z <= 1'b0;
        end
        default: begin
            Y0 <= 1'bx; // Default to don't care state
            z <= 1'bx; // Default to don't care output
        end
    endcase
end

endmodule