module TopModule(
    input  [7:0] in,  
    output parity    
);

reg [7:0] shift_reg;
reg parity_reg;
integer i;

always @(in) begin
    shift_reg = in;
    parity_reg = 1'b0;
    for (i = 0; i < 8; i++) begin
        parity_reg = parity_reg ^ shift_reg[0];
        shift_reg = shift_reg >> 1;
    end
end

assign parity = parity_reg;

endmodule