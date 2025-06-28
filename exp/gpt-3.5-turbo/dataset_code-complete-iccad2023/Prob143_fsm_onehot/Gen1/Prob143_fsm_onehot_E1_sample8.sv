module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// State transition logic
always @* begin
    case(state)
        10'b1_000_000_000: next_state = in ? 10'b0_000_000_001 : 10'b1_000_000_000; // S0
        10'b0_000_000_001: next_state = in ? 10'b0_000_000_010 : 10'b0_000_000_001; // S1
        10'b0_000_000_010: next_state = in ? 10'b0_000_001_001 : 10'b1_000_000_000; // S2
        10'b0_000_001_001: next_state = in ? 10'b0_000_010_001 : 10'b0_000_001_001; // S3
        10'b0_000_010_001: next_state = in ? 10'b0_000_100_001 : 10'b0_000_010_001; // S4
        10'b0_000_100_001: next_state = in ? 10'b0_001_000_001 : 10'b0_000_100_001; // S5
        10'b0_001_000_001: next_state = in ? 10'b0_001_000_001 : 10'b0_001_000_001; // S6
        10'b0_001_000_010: next_state = in ? 10'b0_001_000_100 : 10'b0_001_000_010; // S7
        10'b0_001_000_100: next_state = in ? 10'b0_001_001_000 : 10'b0_001_000_100; // S8
        10'b0_001_001_000: next_state = in ? 10'b0_001_010_000 : 10'b0_001_001_000; // S9
        default: next_state = 10'b1_000_000_000; // Default to S0
    endcase
end

// Output logic
assign out1 = (state == 10'b0_001_000_010) ? 1 : 0; // S5
assign out2 = (state == 10'b0_001_001_000 || state == 10'b0_001_000_100) ? 1 : 0; // S6, S8

endmodule