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
        // else stays at 0 (implied)
    end

    assign tc = ~|counter;

endmodule