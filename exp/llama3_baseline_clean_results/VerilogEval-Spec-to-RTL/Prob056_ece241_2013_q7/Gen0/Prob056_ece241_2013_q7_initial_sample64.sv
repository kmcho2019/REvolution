module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        // No change, Q remains the same
    end else if (j == 1'b0 && k == 1'b1) begin
        // Reset, Q becomes 0
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        // Set, Q becomes 1
        Q <= 1'b1;
    end else if (j == 1'b1 && k == 1'b1) begin
        // Toggle, Q becomes the inverse of its current value
        Q <= ~Q;
    end
end

endmodule