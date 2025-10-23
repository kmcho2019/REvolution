module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register
wire match_seq; // Comparator output

// Comparator for sequence "10011"
assign match_seq = (shift_reg == 5'b10011);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 0;
    end else begin
        // Shift in new input bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Assert MATCH signal if sequence matches
        if (match_seq) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule