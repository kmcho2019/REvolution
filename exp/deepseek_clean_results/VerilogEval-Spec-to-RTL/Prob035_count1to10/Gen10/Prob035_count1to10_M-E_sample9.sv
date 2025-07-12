module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// One-hot encoded states for values 1-10
// Each bit position represents a value (bit 0 = 1, bit 1 = 2, etc.)
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0100;
parameter S4 = 4'b1000;
parameter S5 = 4'b0001; // Cycles back to first 4 bits
parameter S6 = 4'b0010;
parameter S7 = 4'b0100;
parameter S8 = 4'b1000;
parameter S9 = 4'b0001;
parameter S10 = 4'b0010;

always @(posedge clk) begin
    if (reset) begin
        q <= S1;  // Reset to state 1 (0001)
    end
    else begin
        case (q)
            S1: q <= S2;
            S2: q <= S3;
            S3: q <= S4;
            S4: q <= S5;
            S5: q <= S6;
            S6: q <= S7;
            S7: q <= S8;
            S8: q <= S9;
            S9: q <= S10;
            S10: q <= S1;
            default: q <= S1;
        endcase
    end
end

endmodule