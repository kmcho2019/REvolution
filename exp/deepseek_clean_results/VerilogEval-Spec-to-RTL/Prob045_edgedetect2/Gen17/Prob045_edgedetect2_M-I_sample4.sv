module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = in ^ prev_in;
    wire clk_enable = |edge_detect;  // Clock enable when any edge is detected

    always @(posedge clk) begin
        anyedge <= edge_detect;
        if (clk_enable) begin
            prev_in <= in;  // Only update prev_in when needed
        end
    end

endmodule