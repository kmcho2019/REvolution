module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Combine inputs to form address
    wire [2:0] addr = {in1, in2, in3};
    
    // LUT containing all possible outputs
    reg lut_out;
    always @(*) begin
        case(addr)
            3'b000: lut_out = 1'b1;  // XNOR(0,0)=1, XOR(1,0)=1
            3'b001: lut_out = 1'b0;  // XNOR(0,0)=1, XOR(1,1)=0
            3'b010: lut_out = 1'b0;  // XNOR(0,1)=0, XOR(0,0)=0
            3'b011: lut_out = 1'b1;  // XNOR(0,1)=0, XOR(0,1)=1
            3'b100: lut_out = 1'b0;  // XNOR(1,0)=0, XOR(0,0)=0
            3'b101: lut_out = 1'b1;  // XNOR(1,0)=0, XOR(0,1)=1
            3'b110: lut_out = 1'b1;  // XNOR(1,1)=1, XOR(1,0)=1
            3'b111: lut_out = 1'b0;  // XNOR(1,1)=1, XOR(1,1)=0
        endcase
    end
    
    assign out = lut_out;
endmodule