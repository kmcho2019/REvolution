module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_en;
    wire stable;

    // Detect if input is stable (same as previous cycle)
    assign stable = (in == prev_in);
    
    // Clock gating: only enable when input changes
    assign clk_en = ~stable;
    
    // Gated clock
    wire gated_clk;
    assign gated_clk = clk & clk_en;

    always @(posedge gated_clk) begin
        prev_in <= in;
    end

    // Edge detection (combinational)
    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
    end

endmodule