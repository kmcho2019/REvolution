module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;
    wire [7:0] edge_raw = in ^ prev_in;
    wire input_changed = |edge_raw;  // OR reduction for clock gating

    always @(posedge clk) begin
        // Clock gating implementation (synthesis will infer proper gating)
        if (input_changed) begin
            prev_in <= in;
        end
        
        // Pipeline stage for better timing
        edge_detect <= edge_raw;
        anyedge <= edge_detect;
    end

endmodule