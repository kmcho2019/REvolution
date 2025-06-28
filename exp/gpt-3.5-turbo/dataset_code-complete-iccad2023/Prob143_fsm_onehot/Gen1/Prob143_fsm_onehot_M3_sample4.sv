module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

// State transitions and outputs based on the given conditions
always @* begin
    case(state)
        10'b1_0000_0000: begin // S0
            if(in == 0) begin
                next_state = 10'b1_0000_0000; // S0
				out1 = 0;
				out2 = 0;
            end else begin
                next_state = 10'b0_0000_0010; // S1
				out1 = 0;
				out2 = 0;
            end
        end
		10'b0_0000_0001: begin // S1
            if(in == 0) begin
                next_state = 10'b1_0000_0000; // S0
				out1 = 0;
				out2 = 0;
            end else begin
                next_state = 10'b0_0000_0011; // S2
				out1 = 0;
				out2 = 0;
            end
        end
        // Repeat similar cases for all other states defined in the state machine
        default: begin
            next_state = state; // Stay in the same state for unknown conditions
            out1 = 0;
            out2 = 0;
        end
    endcase
end

endmodule