module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// State definitions
localparam [3:0] S0 = 4'b0000,
                 S1 = 4'b0001,
                 S2 = 4'b0010,
                 S3 = 4'b0011,
                 S4 = 4'b0100,
                 S5 = 4'b0101,
                 S6 = 4'b0110,
                 S7 = 4'b0111,
                 S8 = 4'b1000,
                 S9 = 4'b1001;

always @(posedge clk) begin
    if (reset) begin
        q <= S0;  // Reset to state 0
    end
    else if (slowena) begin
        case (q)
            S0: q <= S1;
            S1: q <= S2;
            S2: q <= S3;
            S3: q <= S4;
            S4: q <= S5;
            S5: q <= S6;
            S6: q <= S7;
            S7: q <= S8;
            S8: q <= S9;
            S9: q <= S0;  // Wrap around
            default: q <= S0;
        endcase
    end
end

endmodule