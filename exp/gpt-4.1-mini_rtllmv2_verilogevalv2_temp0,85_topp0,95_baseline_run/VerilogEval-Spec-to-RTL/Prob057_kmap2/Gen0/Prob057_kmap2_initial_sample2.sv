module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Map inputs to indices according to K-map:
    // Rows: cd, Columns: ab
    // Indexing order:
    // c d: 00,01,11,10
    // a b: 00,01,11,10
    
    // Truth table index: {c,d,a,b}
    // Listing all 16 minterms with their outputs:
    // cd\ab: 00 01 11 10
    // 00: 1  1  0  1
    // 01: 1  0  0  1
    // 11: 0  1  1  1
    // 10: 1  1  0  0

    wire [3:0] ab = {a,b};
    wire [3:0] cd = {c,d};

    // Implement with a combinational case statement
    // Or use a lookup table from the truth table.

    // Let's use a case statement on {c,d,a,b}
    wire [3:0] cd_idx = {c,d};
    wire [3:0] ab_idx = {a,b};
    wire [3:0] input_idx = {c,d,a,b};

    reg out_reg;

    always @(*) begin
        case (input_idx)
            4'b0000: out_reg = 1; // c=0,d=0,a=0,b=0
            4'b0001: out_reg = 1; // c=0,d=0,a=0,b=1
            4'b0010: out_reg = 0; // c=0,d=0,a=1,b=0
            4'b0011: out_reg = 1; // c=0,d=0,a=1,b=1

            4'b0100: out_reg = 1; // c=0,d=1,a=0,b=0
            4'b0101: out_reg = 0; // c=0,d=1,a=0,b=1
            4'b0110: out_reg = 0; // c=0,d=1,a=1,b=0
            4'b0111: out_reg = 1; // c=0,d=1,a=1,b=1

            4'b1100: out_reg = 0; // c=1,d=1,a=0,b=0
            4'b1101: out_reg = 1; // c=1,d=1,a=0,b=1
            4'b1110: out_reg = 1; // c=1,d=1,a=1,b=0
            4'b1111: out_reg = 1; // c=1,d=1,a=1,b=1

            4'b1000: out_reg = 1; // c=1,d=0,a=0,b=0
            4'b1001: out_reg = 1; // c=1,d=0,a=0,b=1
            4'b1010: out_reg = 0; // c=1,d=0,a=1,b=0
            4'b1011: out_reg = 0; // c=1,d=0,a=1,b=1

            default: out_reg = 0;
        endcase
    end

    assign out = out_reg;

endmodule