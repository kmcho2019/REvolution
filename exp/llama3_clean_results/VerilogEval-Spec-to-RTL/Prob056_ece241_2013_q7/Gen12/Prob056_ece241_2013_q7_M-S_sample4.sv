module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1;
    end else if (j == 1'b1 && k == 1'b1) begin
        Q <= ~Q;
    end // Implicitly, for j=0 and k=0, Q remains unchanged (Q <= Q)
end

endmodule