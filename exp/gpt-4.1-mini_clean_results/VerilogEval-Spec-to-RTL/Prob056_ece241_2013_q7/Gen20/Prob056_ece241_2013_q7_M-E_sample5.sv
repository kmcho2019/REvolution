module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        // Hold state: Q remains unchanged
        Q <= Q;
    end else if (j == 1'b0 && k == 1'b1) begin
        // Reset state: Q = 0
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        // Set state: Q = 1
        Q <= 1'b1;
    end else begin
        // Toggle state: Q = ~Q
        Q <= ~Q;
    end
end

endmodule