module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (!j && !k) begin
        // No change
        Q <= Q;
    end else if (!j && k) begin
        // Reset
        Q <= 1'b0;
    end else if (j && !k) begin
        // Set
        Q <= 1'b1;
    end else if (j && k) begin
        // Toggle
        Q <= ~Q;
    end
end

endmodule