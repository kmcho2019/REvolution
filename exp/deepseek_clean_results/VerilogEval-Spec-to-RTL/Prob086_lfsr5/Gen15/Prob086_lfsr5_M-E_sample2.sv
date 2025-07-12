module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] tap_mask = 5'b10100; // Positions 4 and 2 (equivalent to taps at 5 and 3)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= {feedback, q[4:1]} ^ (tap_mask & {5{feedback}});
    end
end

endmodule