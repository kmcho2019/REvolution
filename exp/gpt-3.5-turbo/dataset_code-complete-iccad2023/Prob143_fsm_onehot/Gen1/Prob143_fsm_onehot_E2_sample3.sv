module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

// Define the state transitions based on the given conditions
always @* begin
    case(state)
        10'b0000000001: begin // State S0
            next_state = in ? 10'b0000000010 : 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
        10'b0000000010: begin // State S1
            next_state = in ? 10'b0000000100 : 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
        10'b0000000100: begin // State S2
            next_state = in ? 10'b0000001000 : 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
        10'b0000001000: begin // State S3
            next_state = in ? 10'b0000010000 : 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
        10'b0000010000: begin // State S4
            next_state = in ? 10'b0000100000 : 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
        10'b0000100000: begin // State S5
            next_state = in ? 10'b0010000000 : 10'b0001000000;
            out1 = 0;
            out2 = 0;
        end
        10'b0001000000: begin // State S6
            next_state = in ? 10'b1000000000 : 10'b0100000000;
            out1 = 0;
            out2 = 0;
        end
        10'b0010000000: begin // State S7
            next_state = in ? 10'b0010000000 : 10'b0010000000;
            out1 = 0;
            out2 = 1;
        end
        10'b0100000000: begin // State S8
            next_state = in ? 10'b0000000010 : 10'b0000000001;
            out1 = 1;
            out2 = 0;
        end
        10'b1000000000: begin // State S9
            next_state = in ? 10'b0000000010 : 10'b0000000001;
            out1 = 1;
            out2 = 1;
        end
        default: begin
            next_state = 10'b0000000001; // Default to S0 state
            out1 = 0;
            out2 = 0;
        end
    endcase
end

endmodule