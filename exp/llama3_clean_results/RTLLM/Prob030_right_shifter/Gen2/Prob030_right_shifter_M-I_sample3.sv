module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

    initial q = 8'b0;

    always @(posedge clk) begin
        // Directly assign the new input bit to the most significant position
        // and shift the rest of the bits to the right
        q <= {d, q[7:1]};
    end

endmodule