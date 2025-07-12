module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        // No change, stay in the same state
        Q <= Q;
    end else if (j == 1'b0 && k == 1'b1) begin
        // Reset the flip-flop
        Q <= 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        // Set the flip-flop
        Q <= 1'b1;
    end else if (j == 1'b1 && k == 1'b1) begin
        // Toggle the flip-flop
        Q <= ~Q;
    end
end

endmodule