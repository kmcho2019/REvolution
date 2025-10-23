module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        // No change: do nothing, Q retains its value
    end
    else if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0;    // Reset
    end
    else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1;    // Set
    end
    else begin
        Q <= ~Q;      // Toggle when j==1 and k==1
    end
end

endmodule