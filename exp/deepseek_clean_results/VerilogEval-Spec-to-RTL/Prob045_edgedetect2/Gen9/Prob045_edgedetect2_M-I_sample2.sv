module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg clk_en;
    wire input_changed = (in != prev_in);

    always @(posedge clk) begin
        clk_en <= input_changed;
    end

    always @(posedge clk) begin
        if (clk_en) begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end
    end

endmodule