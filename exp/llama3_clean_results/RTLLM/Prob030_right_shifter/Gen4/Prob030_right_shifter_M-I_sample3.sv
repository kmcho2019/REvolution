module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

    initial q = 8'b0;

    always @(posedge clk) begin
        // Explicitly shift the register to the right and insert the new bit at the most significant position
        q <= {d, q[7:1]};
    end

endmodule