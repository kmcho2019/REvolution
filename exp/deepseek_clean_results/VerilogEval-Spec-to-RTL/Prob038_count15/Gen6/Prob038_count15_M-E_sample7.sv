module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire feedback = q[0] ^ q[3];  // LFSR feedback for maximal length sequence
wire all_zeros = ~|q;         // Detect when counter is zero

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        if (all_zeros) begin
            q <= 4'b0001;      // Special case after zero
        end else begin
            q <= {feedback, q[3:1]};  // Shift with feedback
        end
    end
end

endmodule