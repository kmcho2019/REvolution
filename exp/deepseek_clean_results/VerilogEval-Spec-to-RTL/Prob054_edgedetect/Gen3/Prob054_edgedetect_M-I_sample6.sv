module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire input_changed = (in != prev_in);
    wire gated_clk = clk & input_changed;

    always @(posedge clk) begin
        if (input_changed) begin
            pedge <= in & ~prev_in;
        end else begin
            pedge <= 8'b0;
        end
    end

    always @(posedge gated_clk) begin
        prev_in <= in;
    end

endmodule