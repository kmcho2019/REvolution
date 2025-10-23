module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    localparam [3:0] INIT_VALUE = 4'b1000;

    wire feedback;

    // feedback is the inverted XOR of bits out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= INIT_VALUE;
        else
            out <= {out[2:0], feedback};
    end

endmodule