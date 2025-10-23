module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        Q <= Q; // Hold the current state
    end else if (j == 1'b0 && k == 1'b1) begin
        Q <= 1'b0; // Reset the state
    end else if (j == 1'b1 && k == 1'b0) begin
        Q <= 1'b1; // Set the state
    end else begin
        Q <= ~Q; // Toggle the state
    end
end

endmodule