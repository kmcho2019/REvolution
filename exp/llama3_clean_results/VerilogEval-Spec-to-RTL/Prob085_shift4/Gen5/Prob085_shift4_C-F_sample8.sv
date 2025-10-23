module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else if (load) begin
        // Direct assignment for load condition
        q_reg <= data;
    end else if (ena) begin
        // Concise yet explicit shift representation for optimization
        q_reg <= {1'b0, q_reg[3:1]};
    end else begin
        // Explicitly defining no change condition for clarity and optimization
        q_reg <= q_reg;
    end
end

// Output assignment
assign q = q_reg;

endmodule