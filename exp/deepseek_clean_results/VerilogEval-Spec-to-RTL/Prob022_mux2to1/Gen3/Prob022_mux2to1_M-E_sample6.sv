module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Store inputs in a 2-bit register
    reg [1:0] input_reg;
    
    always @(*) begin
        input_reg = {b, a};  // b at [1], a at [0]
    end
    
    // Use sel to index into the register
    assign out = input_reg[sel];
endmodule