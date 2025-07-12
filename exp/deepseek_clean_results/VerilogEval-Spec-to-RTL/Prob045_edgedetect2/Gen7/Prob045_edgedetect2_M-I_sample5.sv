module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg stable;
    wire gated_clk;

    // Detect input stability
    always @(posedge clk) begin
        stable <= (in == prev_in);
        anyedge <= in ^ prev_in;
        prev_in <= in;
    end

    // Simple clock gating
    assign gated_clk = stable ? 1'b0 : clk;

    // Only update registers when needed
    always @(posedge gated_clk) begin
        if (!stable) begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end
    end

endmodule