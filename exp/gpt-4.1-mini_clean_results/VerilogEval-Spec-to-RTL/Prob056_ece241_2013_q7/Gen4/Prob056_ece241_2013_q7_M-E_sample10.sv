module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        // Hold state: Q remains the same
        Q <= Q;
    end else if (j == 0 && k == 1) begin
        // Reset state: Q becomes 0
        Q <= 1'b0;
    end else if (j == 1 && k == 0) begin
        // Set state: Q becomes 1
        Q <= 1'b1;
    end else begin
        // Toggle state: J=1 and K=1
        Q <= ~Q;
    end
end

endmodule