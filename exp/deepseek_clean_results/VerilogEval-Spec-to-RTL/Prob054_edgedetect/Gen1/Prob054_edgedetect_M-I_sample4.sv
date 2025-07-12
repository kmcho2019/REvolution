module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input en,          // Enable signal for power reduction
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] pedge
);

    reg [WIDTH-1:0] prev_in;
    wire gated_clk = clk & en;  // Simple clock gating

    always @(posedge gated_clk) begin
        prev_in <= in;
    end

    always @(posedge clk) begin
        if (en) begin
            pedge <= (~prev_in) & in;
        end else begin
            pedge <= {WIDTH{1'b0}};
        end
    end

endmodule