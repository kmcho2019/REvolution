module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] lfsr;
wire lfsr_next = lfsr[3] ^ lfsr[2] ^ lfsr[0];

// LFSR state to binary count mapping
always @(*) begin
    case(lfsr)
        4'b0001: q = 4'b0000; // 0
        4'b0010: q = 4'b0001; // 1
        4'b0100: q = 4'b0010; // 2
        4'b1000: q = 4'b0011; // 3
        4'b0011: q = 4'b0100; // 4
        4'b0110: q = 4'b0101; // 5
        4'b1100: q = 4'b0110; // 6
        4'b1011: q = 4'b0111; // 7
        4'b0101: q = 4'b1000; // 8
        4'b1010: q = 4'b1001; // 9
        default: q = 4'b0000; // should never occur
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001; // LFSR seed
    end
    else begin
        // Advance LFSR, but reset after count 9 (state 4'b1010)
        if (lfsr == 4'b1010)
            lfsr <= 4'b0001;
        else
            lfsr <= {lfsr[2:0], lfsr_next};
    end
end

endmodule