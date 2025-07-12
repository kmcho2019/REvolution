module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Priority: reset > load > shift (ena)
// Note: Clock gating could be applied to 'ena' signal for power optimization
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;           // Async reset (highest priority)
    end
    else if (load) begin
        q <= data;           // Sync load (medium priority)
    end
    else if (ena) begin
        q <= {1'b0, q[3:1]}; // Sync right shift (lowest priority)
    end
    // No else: q retains value when no operation is active
end

endmodule