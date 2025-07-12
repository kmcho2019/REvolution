module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_is_zero = ~|counter;

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (!counter_is_zero)
            counter <= counter - 1;
        // else remains 0 (implicit)
    end

    assign tc = counter_is_zero;

endmodule