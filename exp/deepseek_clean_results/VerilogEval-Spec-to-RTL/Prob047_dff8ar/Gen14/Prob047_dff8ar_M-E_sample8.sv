module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

// Each stage has a mux to select between shift input or parallel load
always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 8'b0;
    end
    else begin
        // Parallel load implementation using mux-like behavior
        shift_reg <= d;
    end
end

assign q = shift_reg;

endmodule