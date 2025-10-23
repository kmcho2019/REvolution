module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    always @(*) begin
        case ({in1, in2, in3})
            3'b000: out = 1'b1;  // XNOR(0,0)=1, XOR(1,0)=1
            3'b001: out = 1'b0;  // XNOR(0,0)=1, XOR(1,1)=0
            3'b010: out = 1'b0;  // XNOR(0,1)=0, XOR(0,0)=0
            3'b011: out = 1'b1;  // XNOR(0,1)=0, XOR(0,1)=1
            3'b100: out = 1'b0;  // XNOR(1,0)=0, XOR(0,0)=0
            3'b101: out = 1'b1;  // XNOR(1,0)=0, XOR(0,1)=1
            3'b110: out = 1'b1;  // XNOR(1,1)=1, XOR(1,0)=1
            3'b111: out = 1'b0;  // XNOR(1,1)=1, XOR(1,1)=0
            default: out = 1'bx;
        endcase
    end

endmodule