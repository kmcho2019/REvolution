module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load)
            counter <= data;
        else if (|counter)  // Only decrement if counter is non-zero
            counter <= counter - 1;
    end

    assign tc = ~|counter;  // NOR reduction for zero detection

endmodule