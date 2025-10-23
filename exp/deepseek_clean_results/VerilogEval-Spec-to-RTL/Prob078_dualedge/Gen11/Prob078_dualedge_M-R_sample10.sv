module TopModule (
    input clk,
    input d,
    output q
);

    wire clk_edge;
    reg d_store;
    
    // Detect both clock edges
    assign clk_edge = clk ^ ~clk;
    
    // Capture data on both edges
    always @(clk_edge) begin
        d_store <= d;
    end
    
    // Output follows stored data
    assign q = d_store;

endmodule