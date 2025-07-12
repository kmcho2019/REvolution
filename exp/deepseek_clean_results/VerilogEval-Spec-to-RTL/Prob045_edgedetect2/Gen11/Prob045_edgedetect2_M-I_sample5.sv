module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] intermediate;
    reg input_changed;
    wire gated_clk;

    // Clock gating when inputs are stable
    assign input_changed = (in != prev_in);
    assign gated_clk = clk & input_changed;

    always @(posedge gated_clk) begin
        intermediate <= in ^ prev_in;  // Stage 1: XOR operation
        prev_in <= in;                // Store current input
    end

    always @(posedge clk) begin
        anyedge <= intermediate;       // Stage 2: Output registration
    end

endmodule