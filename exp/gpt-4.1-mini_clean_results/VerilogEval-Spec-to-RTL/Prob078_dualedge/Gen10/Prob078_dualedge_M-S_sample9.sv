module TopModule (
    input  clk,
    input  d,
    output reg q
);
    reg d_sampled;

    // Sample input d on positive edge of clk
    always @(posedge clk) begin
        d_sampled <= d;
    end

    // Update output q on negative edge of clk with sampled data
    always @(negedge clk) begin
        q <= d_sampled;
    end

endmodule