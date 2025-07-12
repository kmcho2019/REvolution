module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

reg [4:0] shift_reg;  // 5-bit shift register for sequence storage

// Edge detection for reset (optional but improves reliability)
reg RST_prev;
wire RST_edge;
assign RST_edge = RST && !RST_prev;

always @(posedge CLK) begin
    RST_prev <= RST;
    
    if (RST_edge) begin
        shift_reg <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit and shift out oldest bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Check for pattern match (10011)
        MATCH <= (shift_reg == 5'b10011) && IN;
    end
end

endmodule