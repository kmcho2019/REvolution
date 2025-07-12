module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff = 1'b0, and_ff = 1'b0, or_ff = 1'b0;

    always @(posedge clk) begin
        xor_ff <= x;
        and_ff <= x;
        or_ff  <= x;
    end

    assign z = ~((x ^ xor_ff) | (x & ~and_ff) | (x | ~or_ff));

endmodule