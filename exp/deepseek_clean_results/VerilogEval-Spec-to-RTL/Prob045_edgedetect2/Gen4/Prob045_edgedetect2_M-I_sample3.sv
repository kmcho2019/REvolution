module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in, prev_in2;
    wire input_changed = (in != prev_in2);

    always @(posedge clk) begin
        if (input_changed) begin
            prev_in2 <= in;
            prev_in <= prev_in2;
            anyedge <= in ^ prev_in;
        end
    end

endmodule