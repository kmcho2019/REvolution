module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] lfsr;
wire lfsr_zero = (lfsr == 4'b0000);
wire lfsr_feedback = lfsr[3] ^ lfsr[2];  // Polynomial for maximal-length 4-bit LFSR

// LFSR to binary conversion lookup
always @(*) begin
    case(lfsr)
        4'b0001: q = 4'b0000;
        4'b0010: q = 4'b0001;
        4'b0100: q = 4'b0010;
        4'b1000: q = 4'b0011;
        4'b0011: q = 4'b0100;
        4'b0110: q = 4'b0101;
        4'b1100: q = 4'b0110;
        4'b1011: q = 4'b0111;
        4'b0101: q = 4'b1000;
        4'b1010: q = 4'b1001;
        4'b0111: q = 4'b1010;
        4'b1110: q = 4'b1011;
        4'b1111: q = 4'b1100;
        4'b1101: q = 4'b1101;
        4'b1001: q = 4'b1110;
        4'b0000: q = 4'b1111;  // Should never occur in normal operation
        default: q = 4'b0000;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001;  // Seed value
    end
    else begin
        if (lfsr_zero) begin
            lfsr <= 4'b0001;
        end
        else begin
            lfsr <= {lfsr[2:0], lfsr_feedback};
        end
    end
end

endmodule