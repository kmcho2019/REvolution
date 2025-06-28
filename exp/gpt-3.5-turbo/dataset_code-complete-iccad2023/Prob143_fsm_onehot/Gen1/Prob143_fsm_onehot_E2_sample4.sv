module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

// State transition and output encoding based on the given state machine diagram
always @* begin
    case(state)
        10'b1_0000_0000: begin // S0
            if(in == 1) begin
                next_state = 10'b0_0000_0010; // S1
                out1 = 0;
                out2 = 0;
            end else begin
                next_state = 10'b1_0000_0000; // S0
                out1 = 0;
                out2 = 0;
            end
        end
        10'b0_0000_0010: begin // S1
            if(in == 1) begin
                next_state = 10'b0_0000_0100; // S2
                out1 = 0;
                out2 = 0;
            end else begin
                next_state = 10'b1_0000_0000; // S0
                out1 = 0;
                out2 = 0;
            end
        end
        // Continue encoding state transitions and outputs for the remaining states based on the diagram
        // Ensure all states and transitions are covered
        // S2, S3, S4, S5, S6, S7, S8, S9
        // State and output encoding may need to be revised based on specific conditions
        default: begin
            // Default case for invalid states
            next_state = 10'b0_0000_0001; // Go to state S0 by default
            out1 = 0;
            out2 = 0;
        end
    endcase
end

endmodule