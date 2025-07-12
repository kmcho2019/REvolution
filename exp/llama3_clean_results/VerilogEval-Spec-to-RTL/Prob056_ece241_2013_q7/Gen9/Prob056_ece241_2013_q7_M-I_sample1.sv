module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

always @(posedge clk) begin
    if (j == 1'b0) begin
        if (k == 1'b1) begin
            Q <= 1'b0; // Reset Q when j=0 and k=1
        end else begin
            Q <= Q; // Hold Q when j=0 and k=0
        end
    end else begin // j = 1
        if (k == 1'b0) begin
            Q <= 1'b1; // Set Q when j=1 and k=0
        end else begin
            Q <= ~Q; // Toggle Q when j=1 and k=1
        end
    end
end

endmodule