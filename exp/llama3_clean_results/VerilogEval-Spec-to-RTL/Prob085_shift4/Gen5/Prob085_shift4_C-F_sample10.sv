module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

assign q = q_reg;

wire clk_enable = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else if (clk_enable) begin
        if (load) begin
            // Direct assignment for load condition, allowing synthesis tool to optimize
            q_reg <= data;
        end else if (ena) begin
            // Alternative way to express shift, potentially allowing for technology-specific optimizations
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

endmodule