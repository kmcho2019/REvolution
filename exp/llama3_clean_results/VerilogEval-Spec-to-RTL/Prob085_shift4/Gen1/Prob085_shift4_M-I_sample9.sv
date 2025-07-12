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
        q_reg <= 4'b0;
    end else if (load) begin
        // Direct assignment for load condition, allowing synthesis tool to optimize
        q_reg <= data;
    end else if (ena) begin
        // Alternative way to express shift, potentially allowing for technology-specific optimizations
        q_reg <= {1'b0, q_reg[3:1]};
    end else begin
        // Explicitly defining no change condition to ensure synthesis tool understands intent
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule