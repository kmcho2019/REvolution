module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] change_detect = in ^ prev_in;
    reg enable;

    // Simple activity detector - enable if any input changed
    always @(*) begin
        enable = |change_detect;
    end

    always @(posedge clk) begin
        if (enable) begin
            anyedge <= change_detect;
            prev_in <= in;
        end
    end

endmodule