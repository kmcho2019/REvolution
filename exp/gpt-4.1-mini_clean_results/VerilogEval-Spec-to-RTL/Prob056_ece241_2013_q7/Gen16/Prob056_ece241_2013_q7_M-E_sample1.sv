module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        // Hold state
        Q <= Q;
    end else if (j == 0 && k == 1) begin
        // Reset
        Q <= 1'b0;
    end else if (j == 1 && k == 0) begin
        // Set
        Q <= 1'b1;
    end else begin
        // j == 1 && k == 1: Toggle
        Q <= ~Q;
    end
end

endmodule