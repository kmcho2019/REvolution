module TopModule (
    input clk,
    input in,
    output reg out
);

    reg d_comb;

    // Combinational block to compute XOR
    always @(*) begin
        d_comb = in ^ out;
    end

    // Sequential block to capture XOR result on rising clock edge
    always @(posedge clk) begin
        out <= d_comb;
    end

endmodule