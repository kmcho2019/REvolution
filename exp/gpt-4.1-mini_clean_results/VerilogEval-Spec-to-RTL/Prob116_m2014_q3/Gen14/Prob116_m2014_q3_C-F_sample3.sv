module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Assign input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray-to-binary conversion for row bits (x3,x4)
    // b[1] = g[1]
    // b[0] = g[1] ^ g[0]
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray-to-binary conversion for column bits (x1,x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Combine row and column binary indices into a 4-bit address
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Combinational function implementing the K-map truth table
    // Treat don't-cares as 0 (safe, deterministic)
    function automatic logic f_lookup(input [3:0] addr_in);
        begin
            case (addr_in)
                4'b0000: f_lookup = 1'b0; // row=00 col=00 (d->0)
                4'b0001: f_lookup = 1'b0; // row=00 col=01 (0)
                4'b0010: f_lookup = 1'b0; // row=00 col=10 (d->0)
                4'b0011: f_lookup = 1'b0; // row=00 col=11 (d->0)

                4'b0100: f_lookup = 1'b0; // row=01 col=00 (0)
                4'b0101: f_lookup = 1'b0; // row=01 col=01 (d->0)
                4'b0110: f_lookup = 1'b1; // row=01 col=10 (1)
                4'b0111: f_lookup = 1'b0; // row=01 col=11 (0)

                4'b1000: f_lookup = 1'b1; // row=10 col=00 (1)
                4'b1001: f_lookup = 1'b1; // row=10 col=01 (1)
                4'b1010: f_lookup = 1'b0; // row=10 col=10 (0)
                4'b1011: f_lookup = 1'b0; // row=10 col=11 (d->0)

                4'b1100: f_lookup = 1'b1; // row=11 col=00 (1)
                4'b1101: f_lookup = 1'b1; // row=11 col=01 (1)
                4'b1110: f_lookup = 1'b0; // row=11 col=10 (d->0)
                4'b1111: f_lookup = 1'b0; // row=11 col=11 (d->0)

                default: f_lookup = 1'b0; // safety default
            endcase
        end
    endfunction

    // Assign output by evaluating function on addr
    assign f = f_lookup(addr);

endmodule