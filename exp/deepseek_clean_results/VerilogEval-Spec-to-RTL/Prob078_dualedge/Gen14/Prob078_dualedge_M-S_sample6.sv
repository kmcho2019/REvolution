module TopModule (
    input clk,
    input d,
    output q
);

reg posedge_reg;
reg negedge_reg;

// Capture data on positive clock edge
always @(posedge clk) begin
    posedge_reg <= d;
end

// Capture data on negative clock edge
always @(negedge clk) begin
    negedge_reg <= d;
end

// Output current value based on clock phase
assign q = clk ? posedge_reg : negedge_reg;

endmodule