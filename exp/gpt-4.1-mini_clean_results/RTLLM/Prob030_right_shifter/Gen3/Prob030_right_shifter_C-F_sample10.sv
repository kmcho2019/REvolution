module right_shifter (
    input clk,
    input rst_n,  // Active-low synchronous reset
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (!rst_n)
            q <= 8'b0;              // Synchronous reset to zero
        else
            q <= {d, q[7:1]};      // Right shift with MSB loaded from d
    end

endmodule