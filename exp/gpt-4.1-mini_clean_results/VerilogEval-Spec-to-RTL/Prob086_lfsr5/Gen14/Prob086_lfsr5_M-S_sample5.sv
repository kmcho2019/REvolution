module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // Feedback from bit 0
        wire feedback = q[0];
        q <= {feedback, q[4:1]} ^ (5'b00100 & {5{feedback}}); // XOR feedback only at bit 2 (tap at pos 3)
    end
end

endmodule