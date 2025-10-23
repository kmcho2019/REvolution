module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

always @(posedge clk) begin
    if (j == 1'b1 && k == 1'b1) begin
        Q <= ~Q; // Toggle Q when both j and k are 1
    end else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1; // Set Q to 1 when j is 1 and k is 0
    end else if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0; // Clear Q to 0 when j is 0 and k is 1
    end else begin // j and k are both 0
        // Do nothing, Q retains its current value
    end
end

endmodule