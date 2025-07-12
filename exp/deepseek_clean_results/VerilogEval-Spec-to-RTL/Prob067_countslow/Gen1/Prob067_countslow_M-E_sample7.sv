module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// LFSR state register
reg [3:0] lfsr;

// LFSR next state logic (taps at bits 3 and 2 for maximal length sequence)
wire lfsr_next = lfsr[3] ^ lfsr[2];

// Count value decoder (maps LFSR states to 0-9 sequence)
always @(*) begin
    case(lfsr)
        4'b0000: q = 4'b0000; // 0
        4'b0001: q = 4'b0001; // 1
        4'b0010: q = 4'b0010; // 2
        4'b0100: q = 4'b0011; // 3
        4'b1000: q = 4'b0100; // 4
        4'b0011: q = 4'b0101; // 5
        4'b0110: q = 4'b0110; // 6
        4'b1100: q = 4'b0111; // 7
        4'b1011: q = 4'b1000; // 8
        4'b0101: q = 4'b1001; // 9
        default: q = 4'b0000; // fallback
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0000; // Reset to initial LFSR state
    end
    else if (slowena) begin
        lfsr <= {lfsr[2:0], lfsr_next}; // LFSR shift
        // Wrap around when we reach the end of our sequence
        if (lfsr == 4'b0101) lfsr <= 4'b0000;
    end
end

endmodule