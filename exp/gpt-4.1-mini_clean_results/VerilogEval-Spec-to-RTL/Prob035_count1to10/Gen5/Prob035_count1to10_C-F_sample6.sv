module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Minimal combinational logic to detect count == 10 (decimal)
    wire wrap_around = (q[3] & ~q[2] & q[1] & ~q[0]);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // synchronous reset to 1
        end else begin
            q <= wrap_around ? 4'd1 : q + 4'd1;
        end
    end

endmodule