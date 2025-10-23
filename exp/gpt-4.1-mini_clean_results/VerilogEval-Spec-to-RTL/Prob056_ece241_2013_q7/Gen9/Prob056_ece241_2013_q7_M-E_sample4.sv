module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        Q <= Q;        // Hold state
    end else if (j == 0 && k == 1) begin
        Q <= 1'b0;     // Reset
    end else if (j == 1 && k == 0) begin
        Q <= 1'b1;     // Set
    end else begin
        Q <= ~Q;       // Toggle
    end
end

endmodule