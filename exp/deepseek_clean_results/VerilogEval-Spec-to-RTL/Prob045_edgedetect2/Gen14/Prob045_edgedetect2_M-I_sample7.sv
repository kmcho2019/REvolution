module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect_reg;
    wire [7:0] edge_detect = in ^ prev_in;
    wire input_changed = |edge_detect;  // OR reduction for clock gating

    // Clock gating cell (synthesis will infer proper clock gating)
    wire gated_clk = input_changed ? clk : 1'b0;

    always @(posedge clk) begin
        edge_detect_reg <= edge_detect;  // Pipeline stage for timing
        anyedge <= edge_detect_reg;     // Output registered edge detection
    end

    // Clock-gated always block for prev_in
    always @(posedge gated_clk) begin
        prev_in <= in;  // Only update when inputs change
    end

endmodule