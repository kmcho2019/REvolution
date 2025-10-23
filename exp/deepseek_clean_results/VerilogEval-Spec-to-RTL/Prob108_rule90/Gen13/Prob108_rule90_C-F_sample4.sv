module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Clock gating logic
    wire update_clk;
    assign update_clk = clk & (~load);

    // Synchronous update with optimized boundary handling
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
    end

    // Update with optimized boundary handling (left=0 for q[0], right=0 for q[511])
    always @(posedge update_clk) begin
        q <= {1'b0, q[511:1]} ^ {q[510:0], 1'b0};
    end

endmodule