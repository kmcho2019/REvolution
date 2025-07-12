module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// FSM states encoding
parameter [3:0] S0  = 4'b0000,
                S1  = 4'b0001,
                S2  = 4'b0010,
                S3  = 4'b0011,
                S4  = 4'b0100,
                S5  = 4'b0101,
                S6  = 4'b0110,
                S7  = 4'b0111,
                S8  = 4'b1000,
                S9  = 4'b1001,
                S10 = 4'b1010,
                S11 = 4'b1011;

always @(posedge clk) begin
    if (!rst_n) begin
        out <= S0;  // Reset to initial state
    end else if (valid_count) begin
        case (out)
            S0:  out <= S1;
            S1:  out <= S2;
            S2:  out <= S3;
            S3:  out <= S4;
            S4:  out <= S5;
            S5:  out <= S6;
            S6:  out <= S7;
            S7:  out <= S8;
            S8:  out <= S9;
            S9:  out <= S10;
            S10: out <= S11;
            S11: out <= S0;  // Wrap around
            default: out <= S0;
        endcase
    end
    // If valid_count is low, state remains unchanged
end

endmodule