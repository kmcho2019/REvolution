module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = ~|counter;
    wire clk_enable = ~counter_zero || load;
    wire gated_clk = clk & clk_enable;

    always @(posedge gated_clk) begin
        if (load)
            counter <= data;
        else if (~counter_zero)
            counter <= counter - 1;
    end

    assign tc = counter_zero;

endmodule