module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter CLK_GATE_MODE = 0; // 0=none (default), 1=basic, 2=advanced
    
    reg [7:0] prev_in;
    wire [7:0] edge_detect = in ^ prev_in;
    wire actual_clk;

    generate
        if (CLK_GATE_MODE == 1) begin : basic_gate
            // Basic clock gating - gate when no edges detected
            assign actual_clk = clk & (|edge_detect);
        end
        else if (CLK_GATE_MODE == 2) begin : adv_gate
            // Advanced clock gating with enable flop
            reg enable;
            always @(posedge clk) begin
                enable <= |edge_detect;
            end
            assign actual_clk = clk & enable;
        end
        else begin : no_gate
            // Default mode - no clock gating for best performance
            assign actual_clk = clk;
        end
    endgenerate

    always @(posedge actual_clk) begin
        anyedge <= edge_detect;
        prev_in <= in;
    end

endmodule