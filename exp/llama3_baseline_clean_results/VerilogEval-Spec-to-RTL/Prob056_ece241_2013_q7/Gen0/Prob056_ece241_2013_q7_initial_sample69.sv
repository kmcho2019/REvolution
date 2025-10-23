module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @ (posedge clk) begin
    if (j == 0 && k == 0) begin
        // No change, Q remains the same
    end else if (j == 0 && k == 1) begin
        // Reset, Q becomes 0
        Q <= 0;
    end else if (j == 1 && k == 0) begin
        // Set, Q becomes 1
        Q <= 1;
    end else if (j == 1 && k == 1) begin
        // Toggle, Q becomes the inverse of its current value
        Q <= ~Q;
    end
end

endmodule