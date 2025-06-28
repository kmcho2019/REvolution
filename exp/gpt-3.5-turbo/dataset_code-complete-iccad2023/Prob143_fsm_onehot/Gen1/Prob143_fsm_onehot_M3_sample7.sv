module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

always_comb begin
    case(state)
        10'b1_0000_0000: begin // S0
            next_state = in ? 10'b0_0000_0010 : 10'b1_0000_0000;
            out1 = 0;
            out2 = 0;
        end
        10'b0_0000_0010: begin // S1
            next_state = in ? 10'b0_0000_0100 : 10'b1_0000_0000;
            out1 = 0;
            out2 = 0;
        end
        10'b0_0000_0100: begin // S2
            next_state = in ? 10'b0_0000_1000 : 10'b1_0000_0000;
            out1 = 0;
            out2 = 0;
        end
        10'b0_0000_1000: begin // S3
            next_state = in ? 10'b0_0001_0000 : 10'b1_0000_0000;
            out1 = 0;
            out2 = 0;
        end
        10'b0_0001_0000: begin // S4
            next_state = in ? 10'b0_0010_0000 : 10'b1_0000_0000;
            out1 = 0;
            out2 = 0;
        end
        10'b0_0010_0000: begin // S5
            next_state = in ? 10'b0_0100_0000 : 10'b1_0000_1000;
            out1 = 0;
            out2 = 0;
        end
        10'b0_0100_0000: begin // S6
            next_state = in ? 10'b0_1000_0000 : 10'b1_0000_0100;
            out1 = 0;
            out2 = 0;
        end
        10'b0_1000_0000: begin // S7
            next_state = in ? 10'b0_0000_0001 : 10'b1_0000_0000;
            out1 = 0;
            out2 = 1;
        end
        10'b0_0000_0001: begin // S8
            next_state = in ? 10'b0_0000_0010 : 10'b1_0000_0000;
            out1 = 1;
            out2 = 0;
        end
        10'b1_0000_0000: begin // S9
            next_state = in ? 10'b0_0000_0010 : 10'b1_0000_0000;
            out1 = 1;
            out2 = 1;
        end
        default: begin
            next_state = 10'b0_0000_0001; // Go to S0 as default
            out1 = 0;
            out2 = 0;
        end
    endcase
end

endmodule