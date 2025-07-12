module TopModule(
    input a,
    input b,
    output reg out
);
    always @(*) begin
        case ({a, b})
            2'b00: out = 1'b1;  // NOR(0,0) = 1
            2'b01: out = 1'b0;  // NOR(0,1) = 0
            2'b10: out = 1'b0;  // NOR(1,0) = 0
            2'b11: out = 1'b0;  // NOR(1,1) = 0
        endcase
    end
endmodule