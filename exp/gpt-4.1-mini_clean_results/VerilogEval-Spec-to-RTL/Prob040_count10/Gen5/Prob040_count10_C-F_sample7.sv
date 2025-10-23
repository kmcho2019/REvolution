module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

    // Check if q is 9 (4'b1001) using minimal combinational logic
    wire is_nine = q[3] & ~q[2] & q[1] & q[0];

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= is_nine ? 4'd0 : q + 1;
    end

endmodule