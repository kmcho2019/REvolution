module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor_q = 0;
    reg ff_and_q = 0;
    reg ff_or_q  = 0;

    wire ff_xor_d = x ^ ff_xor_q;
    wire ff_and_d = x & (~ff_and_q);
    wire ff_or_d  = x | (~ff_or_q);

    always @(posedge clk) begin
        ff_xor_q <= ff_xor_d;
        ff_and_q <= ff_and_d;
        ff_or_q  <= ff_or_d;
    end

    assign z = ~(ff_xor_q | ff_and_q | ff_or_q);

endmodule