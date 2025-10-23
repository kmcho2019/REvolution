module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg; // internal register for output
    integer i; // loop variable

    always @(*) begin
        pos_reg = 3'd0; // default output to 0
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i]) begin
                pos_reg = i; // output position of first '1'
                break;
            end
        end
        pos = pos_reg; // assign internal register to output
    end

endmodule