module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    parameter WIDTH = 8;
    reg [WIDTH-1:0] prev_in;
    reg [WIDTH-1:0] edge_detect;
    wire clk_enable = (in != prev_in);  // Clock gating condition

    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;            // Store previous input only when needed
        end
        edge_detect <= ~prev_in;      // Stage 1: Invert previous value
        pedge <= in & edge_detect;    // Stage 2: Final AND operation
    end

endmodule