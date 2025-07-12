module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg clk_d;
    reg q_int;

    // Sample previous clk state
    always @(posedge clk) begin
        clk_d <= clk;
    end

    wire edge_detect = clk ^ clk_d; // High for one clk cycle at every clk edge (both edges)

    // On each rising edge of clk, if an edge detected, sample d
    always @(posedge clk) begin
        if (edge_detect)
            q_int <= d;
    end

    // Output registered q_int
    always @(posedge clk) begin
        q <= q_int;
    end

endmodule