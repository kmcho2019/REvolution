module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] lfsr;
wire feedback;

// Maximal-length LFSR for 4 bits (taps at positions 4 and 3)
assign feedback = lfsr[3] ^ lfsr[2];

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001;  // LFSR cannot be all zeros
    end else begin
        lfsr <= {lfsr[2:0], feedback};
    end
end

// Convert LFSR state to binary count
// This lookup table maps each LFSR state to its corresponding count value
assign q = (lfsr == 4'b0001) ? 4'd0 :
           (lfsr == 4'b0010) ? 4'd1 :
           (lfsr == 4'b0100) ? 4'd2 :
           (lfsr == 4'b1000) ? 4'd3 :
           (lfsr == 4'b0011) ? 4'd4 :
           (lfsr == 4'b0110) ? 4'd5 :
           (lfsr == 4'b1100) ? 4'd6 :
           (lfsr == 4'b1011) ? 4'd7 :
           (lfsr == 4'b0101) ? 4'd8 :
           (lfsr == 4'b1010) ? 4'd9 :
           (lfsr == 4'b0111) ? 4'd10 :
           (lfsr == 4'b1110) ? 4'd11 :
           (lfsr == 4'b1111) ? 4'd12 :
           (lfsr == 4'b1101) ? 4'd13 :
           (lfsr == 4'b1001) ? 4'd14 :
           4'd15;  // when lfsr == 4'b0001 (wrapped around)

endmodule