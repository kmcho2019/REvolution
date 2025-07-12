module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Single always block for all flip-flops
always @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset all bits to 0
    end else begin
        q <= d;              // Normal operation
    end
end

/* Alternative implementation using generate (uncomment if preferred)
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
        always @(posedge clk) begin
            if (reset) q[i] <= 1'b0;
            else q[i] <= d[i];
        end
    end
endgenerate
*/

endmodule