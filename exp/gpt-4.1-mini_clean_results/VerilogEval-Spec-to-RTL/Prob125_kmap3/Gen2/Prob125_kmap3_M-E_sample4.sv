module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire [3:0] addr;
    reg lut_out;

    // Address mapping: {c,d,a,b}
    assign addr = {c, d, a, b};

    always @(*) begin
        case (addr)
            4'b0000: lut_out = 1'b0; // c=0 d=0 a=0 b=0
            4'b0001: lut_out = 1'b0; // c=0 d=0 a=0 b=1 (don't care assigned 0)
            4'b0010: lut_out = 1'b1; // c=0 d=0 a=1 b=0
            4'b0011: lut_out = 1'b1; // c=0 d=0 a=1 b=1
            4'b0100: lut_out = 1'b0; // c=0 d=1 a=0 b=0
            4'b0101: lut_out = 1'b0; // c=0 d=1 a=0 b=1
            4'b0110: lut_out = 1'b0; // c=0 d=1 a=1 b=0 (don't care assigned 0)
            4'b0111: lut_out = 1'b0; // c=0 d=1 a=1 b=1 (don't care assigned 0)
            4'b1100: lut_out = 1'b0; // c=1 d=1 a=0 b=0
            4'b1101: lut_out = 1'b1; // c=1 d=0 a=0 b=1
            4'b1110: lut_out = 1'b1; // c=1 d=1 a=1 b=0
            4'b1111: lut_out = 1'b1; // c=1 d=1 a=1 b=1
            4'b1000: lut_out = 1'b1; // c=1 d=0 a=0 b=0
            4'b1001: lut_out = 1'b1; // c=1 d=0 a=0 b=1
            4'b1010: lut_out = 1'b1; // c=1 d=0 a=1 b=0
            4'b1011: lut_out = 1'b1; // c=1 d=0 a=1 b=1
            default: lut_out = 1'b0; // default safety
        endcase
    end

    assign out = lut_out;

endmodule