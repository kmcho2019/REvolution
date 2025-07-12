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
        else if (~|counter)  // NOR reduction for zero check
            counter <= 10'b0;
        else
            counter <= counter - 1;
    end

    assign tc = ~|counter;  // Shared zero detection logic

endmodule