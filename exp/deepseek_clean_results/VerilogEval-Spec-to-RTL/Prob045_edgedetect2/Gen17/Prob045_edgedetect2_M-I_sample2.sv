module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] input_changed = in ^ prev_in;
    wire any_change = |input_changed;  // OR reduction for clock gating

    // Clock gating cell (integrated in modern libraries)
    wire gated_clk;
    assign gated_clk = clk & any_change;

    always @(posedge gated_clk) begin
        prev_in <= in;
    end

    // Output register with enable (only updates when changes occur)
    always @(posedge clk) begin
        if (any_change) begin
            anyedge <= input_changed;
        end else begin
            anyedge <= 8'b0;  // Clear output when no changes
        end
    end

endmodule