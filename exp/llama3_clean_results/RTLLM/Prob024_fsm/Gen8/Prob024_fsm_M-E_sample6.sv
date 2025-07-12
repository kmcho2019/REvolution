module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the shift register
reg [4:0] shift_reg;

// Define the desired pattern
reg [4:0] pattern = 5'b10011;

// Shift register logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg = 5'b00000;
        MATCH = 1'b0;
    end else begin
        shift_reg = {shift_reg[3:0], IN};
        MATCH = (shift_reg == pattern);
    end
end

endmodule