module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire input_changed;

    assign input_changed = |(in ^ prev_in);

    always @(posedge clk) begin
        if (input_changed) begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end else begin
            anyedge <= 8'b0;
        end
    end
endmodule