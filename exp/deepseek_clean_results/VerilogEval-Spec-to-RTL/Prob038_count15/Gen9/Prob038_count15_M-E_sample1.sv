module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire feedback = q[3] ^ q[2];  // Feedback polynomial: x^4 + x^3 + 1
wire all_ones = &q;           // Detect when counter is 1111

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        if (q == 4'b0000) begin
            q <= 4'b0001;     // Special case to start sequence
        end
        else if (all_ones) begin
            q <= 4'b0000;      // Complete the cycle after 1111
        end
        else begin
            q <= {q[2:0], feedback};  // Normal LFSR operation
        end
    end
end

endmodule