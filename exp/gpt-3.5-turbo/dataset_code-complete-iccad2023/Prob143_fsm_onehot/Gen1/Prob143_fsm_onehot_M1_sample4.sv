module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Define states
parameter S0 = 10'b1_000_000_000;
parameter S1 = 10'b0_000_000_001;
parameter S2 = 10'b0_000_000_011;
parameter S3 = 10'b0_000_001_001;
parameter S4 = 10'b0_000_010_001;
parameter S5 = 10'b0_000_100_001;
parameter S6 = 10'b0_001_000_001;
parameter S7 = 10'b0_001_000_010;
parameter S8 = 10'b0_001_000_100;
parameter S9 = 10'b0_001_001_000;

// State transition logic
always @* begin
    case(state)
        S0: next_state = (in) ? S1 : S0;
        S1: next_state = (in) ? S2 : S0;
        S2: next_state = (in) ? S3 : S0;
        S3: next_state = (in) ? S4 : S0;
        S4: next_state = (in) ? S5 : S0;
        S5: next_state = (in) ? S6 : S8;
        S6: next_state = (in) ? S7 : S9;
        S7: next_state = (in) ? S7 : S0;
        S8: next_state = (in) ? S1 : S0;
        S9: next_state = (in) ? S1 : S0;
        default: next_state = S0;
    endcase
end

// Output logic
assign out1 = (state == S5) ? 1 : 0;
assign out2 = (state == S6 || state == S7) ? 1 : 0;

endmodule