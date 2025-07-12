module right_shifter (
    input clk,
    input reset,
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            q <= {d, q[7:1]};
    end

endmodule