module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] data_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Parallel reset of all bits
        data_reg <= 8'b0;
    end else begin
        // Shift register behavior with parallel load
        data_reg <= d;
    end
end

// Direct assignment of outputs
assign q = data_reg;

endmodule