module TopModule #(
    parameter WIDTH = 10
) (
    input clk,
    input load,
    input [WIDTH-1:0] data,
    output tc
);

    reg [WIDTH-1:0] counter;
    wire count_enable = (counter != 0) && !load;
    wire gated_clk = clk & count_enable;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end
    end

    always @(posedge gated_clk) begin
        if (count_enable) begin
            counter <= counter - 1;
        end
    end

    // Optimized comparison - only check LSB when counter is small
    assign tc = (counter == 0);

endmodule