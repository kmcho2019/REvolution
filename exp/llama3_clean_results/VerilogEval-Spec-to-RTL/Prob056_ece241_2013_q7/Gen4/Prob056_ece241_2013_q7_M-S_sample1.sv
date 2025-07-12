module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0) begin
        Q <= Q; // Qold
    end else if (j == 0 && k == 1) begin
        Q <= 0;
    end else if (j == 1 && k == 0) begin
        Q <= 1;
    end else begin // j == 1 && k == 1
        Q <= ~Q; // ~Qold
    end
end

endmodule