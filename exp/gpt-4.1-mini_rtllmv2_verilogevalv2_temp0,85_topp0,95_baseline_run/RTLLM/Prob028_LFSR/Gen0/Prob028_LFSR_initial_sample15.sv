module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    wire feedback;

    // Calculate feedback as inverted XOR of out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule