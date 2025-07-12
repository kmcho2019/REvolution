module TopModule (
    input clk,
    input d,
    output q
);

    reg sampled_data;
    reg delayed_clk;
    
    // Create a delayed version of the clock
    always @(posedge clk) begin
        delayed_clk <= ~delayed_clk;
    end
    
    // Edge detection using XOR
    wire clk_edge = clk ^ delayed_clk;
    
    // Capture data on both edges
    always @(posedge clk_edge) begin
        sampled_data <= d;
    end
    
    assign q = sampled_data;

endmodule