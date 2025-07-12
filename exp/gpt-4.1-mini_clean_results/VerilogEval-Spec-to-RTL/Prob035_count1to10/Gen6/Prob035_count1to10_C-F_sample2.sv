module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect count == 10 (decimal) with minimal combinational logic
    wire wrap_around = q[3] & ~q[2] & q[1] & ~q[0];

    // Next state logic separated into combinational signal
    wire [3:0] next_q = wrap_around ? 4'd1 : q + 4'd1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // synchronous reset to 1
        end else begin
            q <= next_q;
        end
    end

endmodule