module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

// Define an enumeration for the states
enum logic [3:0] {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} state, next_state;

// Sequential logic to update the state
always @(posedge clk) begin
    if (reset) begin
        state <= S1; // Reset to state S1 (count 1)
    end else begin
        case (state)
            S1: state <= S2;
            S2: state <= S3;
            S3: state <= S4;
            S4: state <= S5;
            S5: state <= S6;
            S6: state <= S7;
            S7: state <= S8;
            S8: state <= S9;
            S9: state <= S10;
            S10: state <= S1; // Wrap around to S1
            default: state <= S1; // Default to S1 for any other state
        endcase
    end
end

// Combinational logic to map states to output
always_comb begin
    case (state)
        S1: q = 4'd1;
        S2: q = 4'd2;
        S3: q = 4'd3;
        S4: q = 4'd4;
        S5: q = 4'd5;
        S6: q = 4'd6;
        S7: q = 4'd7;
        S8: q = 4'd8;
        S9: q = 4'd9;
        S10: q = 4'd10;
        default: q = 4'd1; // Default output for any other state
    endcase
end

endmodule