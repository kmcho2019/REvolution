module TopModule (
    input  wire a,
    input  wire b,
    output reg  out_and,
    output reg  out_or,
    output reg  out_xor,
    output reg  out_nand,
    output reg  out_nor,
    output reg  out_xnor,
    output reg  out_anotb
);

    // Combine inputs into a 2-bit selector
    wire [1:0] sel = {a, b};

    // Combinational block to compute outputs using a case statement acting like a LUT
    always @(*) begin
        // Default outputs to zero
        out_and   = 1'b0;
        out_or    = 1'b0;
        out_xor   = 1'b0;
        out_nand  = 1'b1; // NAND default is 1, inverse of AND
        out_nor   = 1'b1; // NOR default is 1, inverse of OR
        out_xnor  = 1'b1; // XNOR default is 1, inverse of XOR
        out_anotb = 1'b0;

        case (sel)
            2'b00: begin
                // a=0, b=0
                out_and   = 1'b0 & 1'b0;  // 0
                out_or    = 1'b0 | 1'b0;  // 0
                out_xor   = 1'b0 ^ 1'b0;  // 0
                out_nand  = ~(1'b0 & 1'b0); // 1
                out_nor   = ~(1'b0 | 1'b0);  // 1
                out_xnor  = ~(1'b0 ^ 1'b0);  // 1
                out_anotb = 1'b0 & ~1'b0;     // 0
            end
            2'b01: begin
                // a=0, b=1
                out_and   = 1'b0 & 1'b1;  // 0
                out_or    = 1'b0 | 1'b1;  // 1
                out_xor   = 1'b0 ^ 1'b1;  // 1
                out_nand  = ~(1'b0 & 1'b1); // 1
                out_nor   = ~(1'b0 | 1'b1);  // 0
                out_xnor  = ~(1'b0 ^ 1'b1);  // 0
                out_anotb = 1'b0 & ~1'b1;     // 0
            end
            2'b10: begin
                // a=1, b=0
                out_and   = 1'b1 & 1'b0;  // 0
                out_or    = 1'b1 | 1'b0;  // 1
                out_xor   = 1'b1 ^ 1'b0;  // 1
                out_nand  = ~(1'b1 & 1'b0); // 1
                out_nor   = ~(1'b1 | 1'b0);  // 0
                out_xnor  = ~(1'b1 ^ 1'b0);  // 0
                out_anotb = 1'b1 & ~1'b0;     // 1
            end
            2'b11: begin
                // a=1, b=1
                out_and   = 1'b1 & 1'b1;  // 1
                out_or    = 1'b1 | 1'b1;  // 1
                out_xor   = 1'b1 ^ 1'b1;  // 0
                out_nand  = ~(1'b1 & 1'b1); // 0
                out_nor   = ~(1'b1 | 1'b1);  // 0
                out_xnor  = ~(1'b1 ^ 1'b1);  // 1
                out_anotb = 1'b1 & ~1'b1;     // 0
            end
        endcase
    end

endmodule