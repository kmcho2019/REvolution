module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_q = 1'b0;
    reg and_q = 1'b0;
    reg or_q  = 1'b0;

    always @(posedge clk) begin
        xor_q <= x ^ xor_q;
        and_q <= x & ~and_q;
        or_q  <= x | ~or_q;
    end

    assign z = ~(xor_q | and_q | or_q);

endmodule