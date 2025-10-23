module TopModule(
    input clk,
    input d,
    output reg q
);

    reg clk_dly;
    reg edge_detect;

    // Delay clk by one cycle
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Generate enable pulse on both edges by comparing clk and delayed clk
    always @(posedge clk) begin
        // edge_detect is high if clk and clk_dly differ, indicating an edge (pos or neg)
        // Since clk_dly is clk delayed by one posedge, a change between clk and clk_dly means clk edge occurred
        edge_detect <= (clk ^ clk_dly);
    end

    // Dual-edge triggered behavior emulated by sampling d when edge_detect is high
    always @(posedge clk) begin
        if (edge_detect)
            q <= d;
    end

endmodule