module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter USE_CLK_GATE = 0; // 0=disabled, 1=enabled
    
    reg [7:0] prev_in;
    wire [7:0] edge_detect = in ^ prev_in;
    wire gated_clk;

    generate
        if (USE_CLK_GATE) begin : clock_gate
            // Proper clock gating implementation
            reg enable;
            always @(posedge clk) begin
                enable <= |edge_detect;
            end
            // This would typically be implemented with a library clock gating cell
            assign gated_clk = clk & enable;
        end
        else begin : no_clock_gate
            assign gated_clk = clk;
        end
    endgenerate

    always @(posedge gated_clk) begin
        prev_in <= in;
        anyedge <= edge_detect;
    end

endmodule