module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle
    wire [7:0] edge_detect = in ^ prev_in;
    wire inputs_stable = (in == prev_in);  // Stability detection
    
    // Clock gating logic
    wire gated_clk;
    assign gated_clk = inputs_stable ? 1'b0 : clk;
    
    always @(posedge clk) begin
        anyedge <= edge_detect;  // Main output always clocked
    end
    
    always @(posedge gated_clk) begin
        prev_in <= in;           // Only update when inputs change
    end

endmodule