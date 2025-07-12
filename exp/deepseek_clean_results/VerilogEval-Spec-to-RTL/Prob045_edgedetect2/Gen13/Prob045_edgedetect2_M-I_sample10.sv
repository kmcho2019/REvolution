module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_enable = (in != prev_in); // Clock gating condition
    
    // Hierarchical XOR implementation
    wire [7:0] edge_detect = in ^ prev_in;
    
    // Clock gated always block
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;
        end
    end
    
    // Direct combinational output (removes output register)
    assign anyedge = edge_detect;

endmodule