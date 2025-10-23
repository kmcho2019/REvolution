module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register to hold the sequence

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset the shift register
        MATCH <= 1'b0;
    end else begin
        // Shift the input into the register
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Check if the current sequence matches "10011" and the current input is '1'
        if(shift_reg == 5'b10011 && IN == 1'b1) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule