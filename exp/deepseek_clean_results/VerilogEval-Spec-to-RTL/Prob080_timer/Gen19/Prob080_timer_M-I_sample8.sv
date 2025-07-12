module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_zero = (counter == 0);
    wire [9:0] next_counter = load ? data : counter - 1'b1;
    wire counter_enable = load || !counter_zero;

    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= next_counter;
        end
    end

    assign tc = counter_zero;

endmodule