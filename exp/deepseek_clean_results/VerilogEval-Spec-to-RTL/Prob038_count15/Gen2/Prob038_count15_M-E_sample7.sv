module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire feedback = q[3] ^ q[2];  // XOR feedback for maximal-length sequence

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        if (q == 4'b0000) begin
            q <= 4'b0001;  // Special case to include zero in sequence
        end else begin
            q <= {q[2:0], feedback};  // Shift left and insert feedback
            if (q == 4'b1011) begin   // Adjust to complete full cycle
                q <= 4'b0000;
            end
        end
    end
end

endmodule