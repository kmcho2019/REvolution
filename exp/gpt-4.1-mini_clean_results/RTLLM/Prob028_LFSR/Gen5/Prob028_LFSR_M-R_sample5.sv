module LFSR (
    input  wire       clk,
    input  wire       rst,    // Active high synchronous reset
    output reg  [3:0] out
);

    wire feedback;
    // Calculate feedback continuously as inverted XOR of out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    // Sequential block for state update with synchronous reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule