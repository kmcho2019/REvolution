module TopModule (
    input [2:0] a,
    output reg [15:0] q
);

always @(*) begin
    case (a)
        3'd0: q = 16'h1232;
        3'd1: q = 16'haee0;
        3'd2: q = 16'h27d4;
        3'd3: q = 16'h5a0e;
        3'd4: q = 16'h2066;
        3'd5: q = 16'h64ce;
        3'd6: q = 16'hc526;
        3'd7: q = 16'h2f19;
        default: q = 16'h0000;
    endcase
end

// Alternative polynomial hash implementation (commented out as it doesn't match all cases)
// wire [15:0] squared = a * a;
// wire [15:0] scaled = squared * 16'd137;
// wire [15:0] xored = scaled ^ 16'h55aa;
// wire [15:0] rotated = {xored[7:0], xored[15:8]};
// wire [15:0] hashed = rotated % 16'd17;
// assign q = (hashed << 12) | (hashed << 8) | (hashed << 4) | hashed;

endmodule