module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 10'b0);
    wire gated_clk = clk & (~counter_zero | load);

    always @(posedge gated_clk) begin
        if (load) begin
            counter <= data;
        end else if (!counter_zero) begin
            counter <= counter - 1'b1;
        end
    end

    assign tc = counter_zero;

endmodule