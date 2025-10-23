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
        // LFSR with special case for all-zeros
        if (q == 4'b0000) begin
            q <= 4'b0001;
        end else begin
            q <= {q[2:0], feedback};
        end
    end
end

endmodule