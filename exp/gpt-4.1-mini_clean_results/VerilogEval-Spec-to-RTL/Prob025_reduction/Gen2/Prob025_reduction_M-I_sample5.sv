module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg    parity
);
    wire parity_comb = ^in; // XOR reduction for even parity

    always @(posedge clk) begin
        parity <= parity_comb;
    end
endmodule