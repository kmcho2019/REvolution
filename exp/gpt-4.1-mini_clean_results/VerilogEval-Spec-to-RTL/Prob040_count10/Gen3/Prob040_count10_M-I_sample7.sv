module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire wrap;

    // Detect when q == 9 (4'b1001) by combinational logic
    assign wrap = q[3] & q[0] & ~q[2] & ~q[1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else begin
            if (wrap)
                q <= 4'd0;
            else
                q <= q + 4'd1;
        end
    end

endmodule