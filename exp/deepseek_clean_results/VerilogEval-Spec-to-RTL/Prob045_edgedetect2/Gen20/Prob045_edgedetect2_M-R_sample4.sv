module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Sequential elements
    reg [7:0] prev_in;
    
    // Combinational logic
    wire [7:0] edge_detect = in ^ prev_in;
    wire no_edges = ~(|edge_detect);
    wire gated_clk = clk & ~no_edges;
    
    // Update previous input on clock edge
    always @(posedge gated_clk) begin
        prev_in <= in;
    end
    
    // Update output on clock edge
    always @(posedge gated_clk) begin
        anyedge <= edge_detect;
    end

endmodule