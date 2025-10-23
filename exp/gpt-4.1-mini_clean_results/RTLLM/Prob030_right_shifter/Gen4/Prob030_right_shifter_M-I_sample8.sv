module right_shifter (
    input clk,
    input rst,      // synchronous active-high reset
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else
            q <= {d, q[7:1]};
    end

endmodule