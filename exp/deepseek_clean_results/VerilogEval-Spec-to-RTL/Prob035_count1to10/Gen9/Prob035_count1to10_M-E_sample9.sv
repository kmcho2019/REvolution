module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Initialize to 1
    end
    else begin
        // Special case for 10 (1010)
        if (q == 4'b1010) begin
            q <= 4'b0001;
        end
        else begin
            // Rotate left with feedback for sequence generation
            q <= {q[2:0], q[3] ^ (q[2] & q[1])};
        end
    end
end

endmodule