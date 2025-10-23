module TopModule (
    input        clk,
    input  [7:0] in,
    output reg   parity
);

    wire parity_comb;
    assign parity_comb = ^in;

    always @(posedge clk) begin
        parity <= parity_comb;
    end

endmodule