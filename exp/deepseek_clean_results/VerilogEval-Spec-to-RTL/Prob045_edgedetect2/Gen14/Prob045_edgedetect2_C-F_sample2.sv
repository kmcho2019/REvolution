module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter CLK_GATE_MODE = 0; // 0=none, 1=basic, 2=advanced
    
    reg [7:0] prev_in;
    wire [7:0] edge_detect = in ^ prev_in;
    wire gated_clk;

    generate
        if (CLK_GATE_MODE == 1) begin : basic_clock_gate
            // Basic clock gating when no edges detected
            wire no_edges = ~(|edge_detect);
            assign gated_clk = clk & ~no_edges;
        end
        else if (CLK_GATE_MODE == 2) begin : adv_clock_gate
            // Advanced clock gating with enable flop
            reg enable;
            always @(posedge clk) begin
                enable <= |edge_detect;
            end
            assign gated_clk = clk & enable;
        end
        else begin : no_clock_gate
            assign gated_clk = clk;
        end
    endgenerate

    always @(posedge gated_clk) begin
        anyedge <= edge_detect;
        prev_in <= in;
    end

endmodule